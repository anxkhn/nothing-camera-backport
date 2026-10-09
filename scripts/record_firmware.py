"""Record local archive hashes and the published partition hashes."""

import argparse
import json
import re
from pathlib import Path

from reconstruct import ROOT, sha


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--firmware", type=Path, required=True)
    args = parser.parse_args()
    parts = sorted(
        args.firmware.glob("Asteroids_C5.0-260915-2123-image-logical.7z.00[123]")
    )
    if len(parts) != 3:
        raise ValueError("Expected all three archive parts")
    published = (args.firmware / "hash.sha256").read_text()
    records = {
        "build": "Asteroids_C5.0-260915-2123",
        "source": "https://github.com/spike0en/nothing_archive",
        "notice": "Firmware images are property of Nothing Technology Limited. OTA extraction, partition image generation and archiving provided by Nothing Archive.",
        "parts": {p.name: sha(p) for p in parts},
        "images": {
            name: re.search(rf"([a-f0-9]{{64}}) \*\./{name}.img", published).group(1)
            for name in ("system_ext", "vendor", "system", "product", "odm")
        },
    }
    (ROOT / "provenance/firmware.json").write_text(json.dumps(records, indent=2) + "\n")


if __name__ == "__main__":
    main()
