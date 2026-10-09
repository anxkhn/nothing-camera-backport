"""Verify reconstructed ZIP payloads against the original and optional r12 APK."""

import argparse
import hashlib
import json
import zipfile

from reconstruct import read_json, require_hash


def payload(archive):
    return {
        entry.filename: hashlib.sha256(archive.read(entry)).hexdigest()
        for entry in archive.infolist()
        if not entry.is_dir()
    }


def verify(original, rebuilt, reference=None):
    require_hash(original, read_json("inputs.json")["original_apk_sha256"])
    with zipfile.ZipFile(original) as archive:
        old = payload(archive)
    with zipfile.ZipFile(rebuilt) as archive:
        new = payload(archive)
        native_entries = [
            entry
            for entry in archive.infolist()
            if entry.filename.startswith("lib/") and not entry.is_dir()
        ]
        if any(entry.compress_type != zipfile.ZIP_STORED for entry in native_entries):
            raise ValueError(
                "Native library compressed despite extractNativeLibs=false"
            )
    preserved = [name for name in old if name.startswith(("lib/", "assets/"))]
    mismatches = [name for name in preserved if old[name] != new.get(name)]
    if mismatches:
        raise ValueError(f"Original assets/native libraries changed: {mismatches}")
    native = read_json("native-libraries.json")
    added = {name for name in new if name.startswith("lib/") and name not in old}
    if added != {"lib/arm64-v8a/" + name for name in native}:
        raise ValueError(f"Unexpected added native set: {sorted(added)}")
    for name, record in native.items():
        if new["lib/arm64-v8a/" + name] != record["sha256"]:
            raise ValueError(f"Native input changed: {name}")
    report = {
        "original_assets_preserved": sum(
            name.startswith("assets/") for name in preserved
        ),
        "original_native_preserved": sum(name.startswith("lib/") for name in preserved),
        "native_added": len(added),
        "native_total": len(native_entries),
        "native_uncompressed": True,
    }
    if reference:
        require_hash(reference, read_json("inputs.json")["release_apk_sha256"])
        with zipfile.ZipFile(reference) as archive:
            expected = payload(archive)
        names = new.keys() | expected.keys()
        # APK signing changes are verified by apksigner, outside payload equivalence.
        names = {name for name in names if not name.startswith("META-INF/")}
        different = sorted(
            name for name in names if new.get(name) != expected.get(name)
        )
        if different:
            raise ValueError(f"Reference APK payload mismatch: {different}")
        report["reference_payload_files_matched"] = len(names)
    print(json.dumps(report, indent=2))
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", required=True)
    parser.add_argument("--apk", required=True)
    parser.add_argument("--reference")
    args = parser.parse_args()
    verify(args.original, args.apk, args.reference)


if __name__ == "__main__":
    main()
