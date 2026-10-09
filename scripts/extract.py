"""Extract hash-locked camera inputs from local firmware and a connected target."""

import argparse
import subprocess
from pathlib import Path

from reconstruct import read_json, require_hash, run


def image_inputs(args):
    if args.output.exists():
        raise ValueError("Output directory already exists. Choose a fresh path.")
    locks = read_json("firmware.json")
    for partition in ("system_ext", "vendor"):
        require_hash(args.images / (partition + ".img"), locks["images"][partition])
    args.output.mkdir(parents=True)
    original = args.output / "NTCamera.apk"
    run(
        args.fsck,
        "--path=/priv-app/NTCamera/NTCamera.apk",
        f"--extract={original}",
        "--no-preserve-owner",
        args.images / "system_ext.img",
    )
    require_hash(original, read_json("inputs.json")["original_apk_sha256"])
    native = args.output / "native"
    native.mkdir()
    for name, record in read_json("native-libraries.json").items():
        if name == "libc++.so":
            continue
        target = native / name
        run(
            args.fsck,
            f"--path=/lib64/{name}",
            f"--extract={target}",
            "--no-preserve-owner",
            args.images / "vendor.img",
        )
        require_hash(target, record["sha256"])


def target_inputs(args):
    if args.factory.exists() or (args.native / "libc++.so").exists():
        raise ValueError("Factory APK or libc++ destination already exists")
    adb = ["adb"] + (["-s", args.serial] if args.serial else [])
    listing = subprocess.check_output(
        adb + ["shell", "pm", "path", "com.nothing.camera"], text=True
    )
    paths = [
        line.removeprefix("package:").strip()
        for line in listing.splitlines()
        if line.startswith("package:")
    ]
    if len(paths) != 1:
        raise ValueError(
            "Expected one monolithic factory Camera APK. Restore the tested factory version first."
        )
    args.factory.parent.mkdir(parents=True, exist_ok=True)
    args.native.mkdir(parents=True, exist_ok=True)
    run(*adb, "pull", paths[0], args.factory)
    run(*adb, "pull", "/system/lib64/libc++.so", args.native / "libc++.so")
    require_hash(args.factory, read_json("inputs.json")["factory_apk_sha256"])
    require_hash(
        args.native / "libc++.so",
        read_json("native-libraries.json")["libc++.so"]["sha256"],
    )


def archive_inputs(args):
    locks = read_json("firmware.json")
    if args.output.exists():
        raise ValueError("Archive output directory already exists")
    for name, expected in locks["parts"].items():
        require_hash(args.parts / name, expected)
    args.output.mkdir(parents=True)
    first = args.parts / next(iter(locks["parts"]))
    run(
        args.sevenzip,
        "x",
        first,
        f"-o{args.output}",
        "system_ext.img",
        "vendor.img",
        "hash.sha256",
    )
    for partition in ("system_ext", "vendor"):
        require_hash(args.output / (partition + ".img"), locks["images"][partition])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    archive = commands.add_parser("archive")
    archive.add_argument("--parts", type=Path, required=True)
    archive.add_argument("--output", type=Path, required=True)
    archive.add_argument("--sevenzip", default="7zz")
    images = commands.add_parser("images")
    images.add_argument("--images", type=Path, required=True)
    images.add_argument("--output", type=Path, required=True)
    images.add_argument("--fsck", default="fsck.erofs")
    target = commands.add_parser("target")
    target.add_argument("--factory", type=Path, required=True)
    target.add_argument("--native", type=Path, required=True)
    target.add_argument("--serial")
    args = parser.parse_args()
    for name in ("parts", "images", "output", "factory", "native"):
        if getattr(args, name, None):
            setattr(args, name, getattr(args, name).resolve())
    {"archive": archive_inputs, "images": image_inputs, "target": target_inputs}[
        args.command
    ](args)


if __name__ == "__main__":
    main()
