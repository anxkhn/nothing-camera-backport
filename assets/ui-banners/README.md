# UI banners

These graphics present the r12 camera port using real screenshots captured directly on a Nothing Phone 3a running NOS 4.1.

| Asset | Resolution | Recommended use |
| --- | --- | --- |
| [landscape.png](landscape.png) | 1600 × 900 (16:9) | Telegram, Reddit, X, and forum posts |
| [portrait.png](portrait.png) | 1080 × 1920 (9:16) | Stories and vertical feeds |
| [header.png](header.png) | 1600 × 500 | GitHub repository and thread headers |
| [options.png](options.png) | 1600 × 900 (16:9) | Visual guide to dual-view layout options |

The options graphic illustrates four dual-view layouts: moving the picture-in-picture window across the screen, flipping the primary camera, and switching between floating PiP and split-screen mode.

## How to re-render

The banners are designed in clean HTML ([banners.html](banners.html)) with embedded Geist typography.

To render new PNG files from the HTML template, make sure you have Chrome and `playwright-cli` installed, then run from the repo root:

```sh
uv run scripts/banners.py --font .work/Geist.ttf
uv run python scripts/render_banners.py
```

This starts a local lightweight web server, waits for web fonts to load, exports each banner at full resolution, and shuts down cleanly.
