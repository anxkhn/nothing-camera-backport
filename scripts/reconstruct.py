"""Reconstruct r12 from hash-locked OEM inputs and the published delta."""

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import urllib.request
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODELS = ("NtCamUfsRequest", "NtCamUfsImage", "NtCamUfsBuffer", "NtCamUfsHandle")
MODERN = MODELS + ("NtCamUfsResult", "INtCamJpeg")


def read_json(name):
    return json.loads((ROOT / "provenance" / name).read_text())


def sha(path):
    with Path(path).open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def require_hash(path, expected):
    actual = sha(path)
    if actual != expected:
        raise ValueError(
            f"SHA-256 mismatch for {Path(path).name}: {actual}, expected {expected}"
        )


def run(*args, cwd=None):
    subprocess.run([str(a) for a in args], cwd=cwd, check=True)


def copy(source, target):
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, target)


def decode(apk, target):
    run("apktool", "d", apk, "-o", target)


def tree_records(directory):
    return {
        p.relative_to(directory).as_posix(): sha(p)
        for p in sorted(directory.rglob("*"))
        if p.is_file()
        and (
            p.relative_to(directory).parts[0].startswith("smali")
            or p.relative_to(directory).parts[0] in {"res", "lib", "assets", "unknown"}
            or p.relative_to(directory).as_posix()
            in {"AndroidManifest.xml", "apktool.yml"}
        )
    }


def verify_tree(directory):
    expected = read_json("r12-decoded.json")
    actual = tree_records(directory)
    failures = [
        name
        for name in expected.keys() | actual.keys()
        if expected.get(name) != actual.get(name)
    ]
    if failures:
        raise ValueError(
            f"Decoded r12 mismatch in {len(failures)} files: {failures[:20]}"
        )
    print(f"PASS: all {len(expected)} decoded r12 payload files match")


def upstream(work):
    lock = read_json("hiddenapibypass.json")
    name = "hiddenapibypass-6.1.aar"
    aar = work / name
    url = (
        "https://repo.maven.apache.org/maven2/org/lsposed/hiddenapibypass/hiddenapibypass/6.1/"
        + name
    )
    with urllib.request.urlopen(url, timeout=60) as response:
        aar.write_bytes(response.read())
    require_hash(aar, lock[name])
    with zipfile.ZipFile(aar) as archive:
        jar = work / "hiddenapi.jar"
        jar.write_bytes(archive.read("classes.jar"))
    return jar


def decompile(apk, names, output, old=False):
    output.mkdir(parents=True, exist_ok=True)
    for name in names:
        target = output / (name + ".java")
        run(
            "jadx",
            "--single-class",
            "com.nothing.algolib.cameraufs." + name,
            "--single-class-output",
            target,
            "--no-res",
            apk,
        )
        text = target.read_text().replace(
            "import androidx.camera.video.AudioStats;", ""
        )
        text = text.replace("AudioStats.AUDIO_AMPLITUDE_NONE", "0.0")
        if old:
            text = text.replace(
                "package com.nothing.algolib.cameraufs;",
                "package com.anx.camera.bridge.old;",
            )
        target.write_text(text)


def helpers(args, work, decoded):
    sdk = args.sdk
    tools = sdk / "build-tools/36.0.0"
    android = sdk / "platforms/android-36/android.jar"
    hidden = upstream(work)
    decompile(args.original, MODERN, work / "stubs")
    decompile(args.factory, MODELS, work / "old", old=True)
    stub_classes = work / "stub-classes"
    stub_classes.mkdir()
    run(
        "javac",
        "--release",
        "8",
        "-classpath",
        android,
        "-d",
        stub_classes,
        *sorted((work / "stubs").glob("*.java")),
    )
    classes = work / "helper-classes"
    classes.mkdir()
    run(
        "javac",
        "--release",
        "8",
        "-classpath",
        os.pathsep.join(map(str, (android, stub_classes, hidden))),
        "-d",
        classes,
        *sorted((work / "old").glob("*.java")),
        *sorted((ROOT / "src/java").rglob("*.java")),
    )
    helper_jar = work / "helper.jar"
    run("jar", "cf", helper_jar, "-C", classes, ".")
    dex = work / "helper-dex"
    dex.mkdir()
    run(
        tools / "d8",
        "--min-api",
        "34",
        "--lib",
        android,
        "--classpath",
        stub_classes,
        "--output",
        dex,
        helper_jar,
        hidden,
    )
    container = work / "helpers.apk"
    with zipfile.ZipFile(container, "w") as archive:
        archive.write(dex / "classes.dex", "classes.dex")
    disassembled = work / "helper-disassembled"
    run("apktool", "d", "-r", container, "-o", disassembled)
    for prefix in ("com/anx/camera/bridge/old", "org/lsposed"):
        for path in (disassembled / "smali" / prefix).rglob("*.smali"):
            copy(
                path,
                decoded / "smali_classes9" / path.relative_to(disassembled / "smali"),
            )
    for path in (ROOT / "src/smali").rglob("*.smali"):
        generated = disassembled / "smali" / path.relative_to(ROOT / "src/smali")
        require_hash(generated, sha(path))
        copy(path, decoded / "smali_classes9" / path.relative_to(ROOT / "src/smali"))
    for source, name in (
        ("AndroidHiddenApiBypass-LICENSE", "LICENSE"),
        ("AndroidHiddenApiBypass-ATTRIBUTION.txt", "ATTRIBUTION.txt"),
    ):
        copy(
            ROOT / "licenses" / source,
            decoded / "assets/licenses/hiddenapibypass" / name,
        )


def prepare(args):
    lock = read_json("inputs.json")
    require_hash(args.original, lock["original_apk_sha256"])
    require_hash(args.factory, lock["factory_apk_sha256"])
    for tool, version in (("apktool", lock["apktool"]), ("jadx", lock["jadx"])):
        actual = subprocess.check_output([tool, "--version"], text=True).strip()
        if actual != version:
            raise ValueError(f"Use {tool} {version}, found {actual}")
    native = read_json("native-libraries.json")
    for name, record in native.items():
        require_hash(args.native / name, record["sha256"])
    if args.work.exists():
        raise ValueError("Work directory already exists. Choose a new empty work path.")
    args.work.mkdir(parents=True)
    decoded = args.work / "decoded"
    decode(args.original, decoded)
    changes = read_json("patch-files.json")
    for name, record in changes.items():
        if record["before"]:
            require_hash(decoded / name, record["before"])
        elif (decoded / name).exists():
            raise ValueError(f"Added path already exists: {name}")
    run("patch", "--batch", "-p1", "-i", ROOT / "patches/r12.patch", cwd=decoded)
    for name, record in changes.items():
        if record["after"]:
            require_hash(decoded / name, record["after"])
        elif (decoded / name).exists():
            raise ValueError(f"Deleted path still exists: {name}")
    for name in native:
        copy(args.native / name, decoded / "lib/arm64-v8a" / name)
    helpers(args, args.work, decoded)
    verify_tree(decoded)


def build(args):
    decoded = args.work / "decoded"
    verify_tree(decoded)
    run("apktool", "b", decoded, "-o", args.work / "unsigned.apk")
    tools = args.sdk / "build-tools/36.0.0"
    run(
        tools / "zipalign",
        "-f",
        "-P",
        "16",
        "4",
        args.work / "unsigned.apk",
        args.work / "aligned.apk",
    )
    run(tools / "zipalign", "-c", "-P", "16", "4", args.work / "aligned.apk")
    if args.keystore:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        run(
            tools / "apksigner",
            "sign",
            "--ks",
            args.keystore,
            "--ks-key-alias",
            args.alias,
            "--ks-pass",
            "env:CAMERA_KS_PASS",
            "--key-pass",
            "env:CAMERA_KEY_PASS",
            "--out",
            args.output,
            args.work / "aligned.apk",
        )
        run(tools / "apksigner", "verify", "--verbose", args.output)
        run(tools / "zipalign", "-c", "-P", "16", "4", args.output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    prepare_parser = commands.add_parser("prepare")
    for name in ("original", "factory", "native"):
        prepare_parser.add_argument("--" + name, type=Path, required=True)
    build_parser = commands.add_parser("build")
    build_parser.add_argument("--keystore", type=Path)
    build_parser.add_argument("--alias", default="camera")
    build_parser.add_argument(
        "--output", type=Path, default=ROOT / ".work/camera-signed.apk"
    )
    verify_parser = commands.add_parser("verify")
    for command in (prepare_parser, build_parser, verify_parser):
        command.add_argument("--work", type=Path, required=True)
    for command in (prepare_parser, build_parser):
        command.add_argument("--sdk", type=Path, required=True)
    args = parser.parse_args()
    for name in ("work", "original", "factory", "native", "sdk", "keystore", "output"):
        if getattr(args, name, None):
            setattr(args, name, getattr(args, name).resolve())
    if args.command == "prepare":
        prepare(args)
    elif args.command == "build":
        build(args)
    else:
        verify_tree(args.work / "decoded")


if __name__ == "__main__":
    main()
