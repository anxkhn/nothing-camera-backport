"""Serve the asset board and export it through an isolated Playwright session."""

import functools
import http.server
import subprocess
import threading
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(ROOT))
server = http.server.ThreadingHTTPServer(("127.0.0.1", 0), handler)
thread = threading.Thread(target=server.serve_forever, daemon=True)
thread.start()
url = f"http://127.0.0.1:{server.server_port}/assets/ui-banners/banners.html"
session = ["playwright-cli", "-s=camera-art-export"]
try:
    subprocess.run(session + ["open", url, "--browser", "chrome"], check=True, cwd=ROOT)
    code = """async page => {
      await page.evaluate(() => document.fonts.ready);
      const names = ['landscape', 'portrait', 'header', 'options'];
      for (const name of names) {
        await page.locator('#' + name).screenshot({path:'assets/ui-banners/' + name + '.png'});
      }
      return {images: await page.locator('img').evaluateAll(images => images.every(i => i.complete && i.naturalWidth > 0)), exported: names};
    }"""
    subprocess.run(session + ["run-code", code], check=True, cwd=ROOT)
finally:
    subprocess.run(session + ["close"], check=False, cwd=ROOT)
    server.shutdown()
    server.server_close()
