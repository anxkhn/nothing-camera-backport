"""Export a reviewed decoded delta. Never export unchanged OEM files."""

import argparse
import difflib
import hashlib
import json
from pathlib import Path


def sha(path):
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, required=True)
    parser.add_argument("--final", type=Path, required=True)
    parser.add_argument("--helper-java", type=Path, required=True)
    parser.add_argument("--native-record", type=Path, required=True)
    parser.add_argument("--upstream-record", type=Path, required=True)
    parser.add_argument("--upstream-license", type=Path, required=True)
    parser.add_argument("--factory-apk", type=Path, required=True)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    original = {
        p.relative_to(args.original).as_posix(): p
        for p in args.original.rglob("*")
        if p.is_file()
    }
    final = {
        p.relative_to(args.final).as_posix(): p
        for p in args.final.rglob("*")
        if p.is_file() and p.relative_to(args.final).parts[0] not in {"build", "dist"}
    }
    changes, diff = {}, []
    for name in sorted(original.keys() | final.keys()):
        before, after = original.get(name), final.get(name)
        if before and after and sha(before) == sha(after):
            continue
        if name.startswith(
            ("original/", "smali_classes9/", "lib/", "assets/licenses/")
        ):
            continue
        if not (
            name == "AndroidManifest.xml"
            or name == "apktool.yml"
            or name.startswith(("smali", "res/"))
        ):
            raise ValueError(f"Unclassified delta: {name}")
        old = before.read_text() if before else ""
        new = after.read_text() if after else ""
        diff.extend(
            difflib.unified_diff(
                old.splitlines(True),
                new.splitlines(True),
                fromfile=f"a/{name}" if before else "/dev/null",
                tofile=f"b/{name}" if after else "/dev/null",
                n=3,
            )
        )
        changes[name] = {
            "before": sha(before) if before else None,
            "after": sha(after) if after else None,
        }
    (root / "patches/r12.patch").write_text("".join(diff))
    (root / "provenance/patch-files.json").write_text(
        json.dumps(changes, indent=2) + "\n"
    )
    for path in args.helper_java.rglob("*.java"):
        destination = root / "src/java" / path.relative_to(args.helper_java)
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(path.read_bytes())
    helpers = args.final / "smali_classes9/com/anx/camera/bridge"
    for path in helpers.glob("*.smali"):
        destination = root / "src/smali/com/anx/camera/bridge" / path.name
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(path.read_bytes())
    native = json.loads(args.native_record.read_text())
    for name, record in native.items():
        record["source"] = (
            "target:/system/lib64/libc++.so"
            if name == "libc++.so"
            else f"firmware:vendor:/lib64/{name}"
        )
    (root / "provenance/native-libraries.json").write_text(
        json.dumps(native, indent=2) + "\n"
    )
    upstream = json.loads(args.upstream_record.read_text())
    (root / "provenance/hiddenapibypass.json").write_text(
        json.dumps(upstream, indent=2) + "\n"
    )
    (root / "licenses/AndroidHiddenApiBypass-LICENSE").write_bytes(
        args.upstream_license.read_bytes()
    )
    asset = args.final / "assets/licenses/hiddenapibypass/ATTRIBUTION.txt"
    (root / "licenses/AndroidHiddenApiBypass-ATTRIBUTION.txt").write_bytes(
        asset.read_bytes()
    )
    payload = {}
    for name, path in sorted(final.items()):
        if name.startswith(
            ("smali", "res/", "lib/", "assets/", "unknown/")
        ) or name in {"AndroidManifest.xml", "apktool.yml"}:
            payload[name] = sha(path)
    (root / "provenance/r12-decoded.json").write_text(
        json.dumps(payload, indent=2) + "\n"
    )
    (root / "provenance/inputs.json").write_text(
        json.dumps(
            {
                "original_apk_sha256": "89fb2557710f5f858870d4af84e33ffd56c9ffe62127a59962541e8f81ebab59",
                "factory_apk_sha256": sha(args.factory_apk),
                "factory_version": "16.0.01.27.00",
                "release_apk_sha256": "00dd9b077e604fc1482f84085169661bd5849f8373d760672a2f683003ef83ac",
                "apktool": "3.0.3",
                "jadx": "1.5.6",
                "build_tools": "36.0.0",
                "android_api": 36,
                "java_release": 8,
            },
            indent=2,
        )
        + "\n"
    )
    print(
        f"Exported {len(changes)} targeted changes, {len(payload)} reference file hashes"
    )


if __name__ == "__main__":
    main()
