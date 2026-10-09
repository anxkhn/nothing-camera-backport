"""Stage already-extracted, hash-locked inputs without contacting a device."""

import argparse
from pathlib import Path

from reconstruct import copy, read_json, require_hash


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--firmware-native", type=Path, required=True)
    parser.add_argument("--target-libcxx", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise ValueError("Output already exists")
    records = read_json("native-libraries.json")
    sources = {
        name: args.target_libcxx if name == "libc++.so" else args.firmware_native / name
        for name in records
    }
    for name, source in sources.items():
        require_hash(source, records[name]["sha256"])
    for name, source in sources.items():
        copy(source, args.output / name)
    print("PASS: staged exactly 11 unmodified native inputs")


if __name__ == "__main__":
    main()
