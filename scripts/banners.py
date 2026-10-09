# /// script
# dependencies = []
# ///
"""Generate an HTML release-art board with real UI and embedded Geist type."""

import argparse
import base64
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--font", type=Path, required=True)
    args = parser.parse_args()
    font = base64.b64encode(args.font.read_bytes()).decode()
    folder = ROOT / "assets" / "ui-banners"
    folder.mkdir(parents=True, exist_ok=True)
    html = r"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"><link rel="icon" href="data:,"><title>Real Camera UI release banners</title>
<style>
@font-face{font-family:Geist;src:url(data:font/ttf;base64,FONT_DATA) format('truetype');font-weight:100 900}
*{box-sizing:border-box}body{margin:0;background:#ccc9c1;font-family:Geist,Arial,sans-serif;color:#f4f2eb}h1,p{margin:0}.board{display:flex;flex-direction:column;gap:40px;padding:40px;width:max-content}.art{position:relative;overflow:hidden;isolation:isolate;background:#121212}.red{color:#ee443d}.tag{border:1px solid #57544f;display:inline-flex;padding:12px 20px;border-radius:30px;font-size:22px}.phone{overflow:hidden;border:7px solid #31312f;border-radius:34px;background:#080808;box-shadow:0 24px 50px #0004}.phone img{display:block;width:100%;height:100%;object-fit:cover}.rule{height:1px;background:#55534d}.foot{position:absolute;left:65px;bottom:42px;font-size:19px;color:#bcb9b2;letter-spacing:.03em}.landscape{width:1600px;height:900px}.landscape .copy{position:absolute;left:70px;top:86px;width:620px}.landscape h1{font-size:108px;line-height:.96;letter-spacing:-.04em;font-weight:600}.landscape .sub{font-size:33px;line-height:1.35;margin:32px 0 38px;color:#d0cdc6}.landscape .phone{position:absolute;width:285px;height:586px;top:136px}.landscape .one{left:900px;transform:rotate(-7deg)}.landscape .two{left:1210px;top:192px;transform:rotate(7deg)}.landscape .name{font-size:23px;margin-bottom:26px;color:#bcb9b2}.landscape .download{margin-top:47px;font-size:23px}.landscape .download strong{display:block;margin-top:10px;font-weight:400;color:#bcb9b2;font-size:20px}.portrait{width:1080px;height:1920px;background:#f2efe7;color:#171717}.portrait .copy{position:absolute;left:64px;top:78px}.portrait h1{font-size:136px;line-height:.98;letter-spacing:-.04em;font-weight:600}.portrait .sub{font-size:34px;margin-top:35px}.portrait .phone{position:absolute;top:690px;left:200px;width:340px;height:700px;transform:rotate(-8deg)}.portrait .two{left:570px;top:778px;transform:rotate(8deg)}.portrait .features{position:absolute;left:65px;top:1540px;font-size:44px;line-height:1.45;font-weight:500}.portrait .foot{color:#625f58;font-size:21px;bottom:60px}.header{width:1600px;height:500px;background:#f2efe7;color:#171717}.header h1{position:absolute;left:65px;top:75px;font-size:98px;line-height:1.03;letter-spacing:-.04em;font-weight:600}.header p{position:absolute;left:69px;top:304px;font-size:29px}.header .phone{position:absolute;width:182px;height:375px;left:1150px;top:58px;transform:rotate(-8deg)}.header .two{left:1368px;top:127px;transform:rotate(8deg)}.header .foot{color:#625f58;bottom:40px}.options{width:1600px;height:900px;background:#e9e6de;color:#171717}.options h1{position:absolute;left:65px;top:66px;font-size:75px;letter-spacing:-.03em;font-weight:600}.options .screens{position:absolute;top:242px;left:70px;right:70px;display:flex;justify-content:space-between}.options .unit{width:315px}.options .phone{width:245px;height:505px;margin:auto;border-color:#45443f;box-shadow:none}.options .label{font-size:26px;margin-top:25px;text-align:center}.options .foot{color:#625f58;font-size:19px;bottom:26px}.rec{display:inline-block;width:13px;height:13px;background:#e93b35;border-radius:50%;margin-right:12px}.screen-note{position:absolute;right:50px;bottom:40px;color:#bcb9b2;font-size:18px}
</style></head><body><main class="board">
<section id="landscape" class="art landscape">
<div class="copy"><div class="name">Nothing Camera Backport</div><h1>Dual-view.<br>On <span class="red">NOS 4.1.</span></h1><p class="sub">Front and rear recording.<br>Your current OS.</p><div class="tag"><span class="rec"></span>Phone 3a · Experimental r12</div><div class="download">APK + reconstruction kit<strong>github.com/anxkhn/nothing-camera-backport</strong></div></div>
<div class="phone one"><img src="../screenshots/dual-view-pip-moved.png" alt="Actual Camera UI with moved PiP inset"></div><div class="phone two"><img src="../screenshots/dual-view-front-main.png" alt="Actual Camera UI with front main view"></div>
<div class="foot">Keep the factory Camera installed and enabled.</div><div class="screen-note">Real device screenshots</div></section>
<section id="portrait" class="art portrait"><div class="copy"><h1>Both<br>cameras.<br><span class="red">NOS 4.1.</span></h1><p class="sub">The stock Camera backport for Phone 3a.</p></div><div class="phone"><img src="../screenshots/dual-view-pip-moved.png" alt="Moved PiP"></div><div class="phone two"><img src="../screenshots/dual-view-front-main.png" alt="Swapped main camera"></div><div class="features">Move the inset.<br>Swap the main view.<br>Record with audio.</div><div class="foot">Experimental r12 · Real device UI<br>Keep the factory Camera enabled.</div></section>
<section id="header" class="art header"><h1>Dual-view Camera.<br>On <span class="red">NOS 4.1.</span></h1><p>Phone 3a · Separate app · No OS upgrade</p><div class="phone"><img src="../screenshots/dual-view-pip.png" alt="Picture-in-picture UI"></div><div class="phone two"><img src="../screenshots/tuning-controls.png" alt="Actual tuning UI"></div><div class="foot">Experimental community backport · Keep factory Camera</div></section>
<section id="options" class="art options"><h1>Choose your view.</h1><div class="screens"><div class="unit"><div class="phone"><img src="../screenshots/dual-view-pip.png" alt="PiP"></div><p class="label">Picture-in-picture</p></div><div class="unit"><div class="phone"><img src="../screenshots/dual-view-pip-moved.png" alt="Moved inset"></div><p class="label">Drag the inset</p></div><div class="unit"><div class="phone"><img src="../screenshots/dual-view-front-main.png" alt="Front main"></div><p class="label">Swap main camera</p></div><div class="unit"><div class="phone"><img src="../screenshots/dual-view-split.png" alt="Split"></div><p class="label">Split-screen</p></div></div><div class="foot">Real r12 Camera UI on Phone 3a / NOS 4.1. PiP size is fixed.</div></section>
</main></body></html>"""
    html = html.replace(
        ".header .two{left:1368px;top:127px;transform:rotate(8deg)}",
        ".header .two{left:1368px;top:88px;transform:rotate(8deg)}",
    )
    (folder / "banners.html").write_text(html.replace("FONT_DATA", font))
    print(folder / "banners.html")


if __name__ == "__main__":
    main()
