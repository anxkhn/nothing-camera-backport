# Project graphics

Artwork and infographics created for the Nothing Camera backport.

- For banners featuring actual device UI, see the [UI banners gallery](ui-banners/README.md).
- For unedited captures of every camera mode, see the [screenshot gallery](screenshots/README.md).

| Graphic | Dimensions | Purpose |
| --- | --- | --- |
| [header.png](header.png), [SVG](header.svg) | 1600 × 500 | GitHub README and forum header |
| [social-landscape.png](social-landscape.png), [SVG](social-landscape.svg) | 1600 × 900 (16:9) | Landscape social posts (X, Telegram, Reddit) |
| [social-portrait.png](social-portrait.png), [SVG](social-portrait.svg) | 1080 × 1920 (9:16) | Stories and vertical video feeds |
| [social-square.png](social-square.png), [SVG](social-square.svg) | 1080 × 1080 | Square posts and avatars |
| [install-infographic.png](install-infographic.png), [SVG](install-infographic.svg) | 1600 × 900 | Quick installation flow overview |
| [processing-infographic.png](processing-infographic.png), [SVG](processing-infographic.svg) | 1600 × 900 | Factory camera processing architecture |

Typography is converted directly into vector outlines in the SVGs, so they render identically without needing external fonts installed. Exact dimensions and file hashes are tracked in [manifest.json](manifest.json).

## How to generate from source

Download the Geist variable TTF from [Google Fonts](https://github.com/google/fonts/tree/main/ofl/geist) into `.work/Geist.ttf`. The SIL Open Font License is preserved under [licenses](../licenses/Geist-OFL.txt).

Ensure `rsvg-convert` is installed, then run from the repo root:

```sh
uv run scripts/artwork.py --font .work/Geist.ttf
```

This compiles all six SVG/PNG pairs and a contact sheet using Pillow and fontTools. Dot-matrix typography and camera shapes are generated programmatically in the script.
