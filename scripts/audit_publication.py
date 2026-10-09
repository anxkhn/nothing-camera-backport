"""Validate the publishable allowlist and write its size/hash inventory."""

import json

from reconstruct import ROOT, sha

FOLDERS = {
    "scripts",
    "patches",
    "src",
    "tests",
    "licenses",
    "provenance",
    "docs",
    "assets",
    ".github",
}
ROOT_FILES = {"README.md", "LICENSE", ".gitignore"}
FORBIDDEN = {".apk", ".aar", ".jar", ".dex", ".so", ".img", ".p12", ".jks", ".keystore"}


def main():
    records = {}
    for path in sorted(ROOT.rglob("*")):
        relative = path.relative_to(ROOT)
        if (
            not path.is_file()
            or relative.parts[0] in {".work", ".git", ".ruff_cache", ".playwright-cli"}
            or "__pycache__" in relative.parts
        ):
            continue
        if relative.parts[0] not in FOLDERS and relative.as_posix() not in ROOT_FILES:
            raise ValueError(f"Outside publication allowlist: {relative}")
        if path.suffix in FORBIDDEN or ".7z" in path.name:
            raise ValueError(f"Binary or private input in publication: {relative}")
        if path.suffix == ".png":
            if relative.parts[0] != "assets" or not path.read_bytes().startswith(
                b"\x89PNG\r\n\x1a\n"
            ):
                raise ValueError(f"Unexpected raster asset: {relative}")
            data = ""
        else:
            data = path.read_text()
        if "/" + "Users/" in data or "BEGIN " + "PRIVATE KEY" in data:
            raise ValueError(
                f"Private host path or signing material in publication: {relative}"
            )
        if relative.as_posix() != "provenance/files.json":
            records[relative.as_posix()] = {
                "bytes": path.stat().st_size,
                "sha256": sha(path),
            }
    (ROOT / "provenance/files.json").write_text(json.dumps(records, indent=2) + "\n")
    print(
        f"PASS: {len(records)} publishable files plus this inventory, {sum(r['bytes'] for r in records.values())} bytes"
    )


if __name__ == "__main__":
    main()
