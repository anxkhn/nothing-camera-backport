# /// script
# dependencies = ["fonttools==4.60.1", "pillow==11.3.0"]
# ///
"""Render original release artwork as self-contained SVG and PNG."""

import argparse
import hashlib
import json
import subprocess
from pathlib import Path

from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont
from PIL import Image, ImageDraw, ImageOps

ROOT = Path(__file__).resolve().parent.parent
WHITE = "#f2f0e9"
BLACK = "#131313"
RED = "#d82726"
GRAY = "#a19f98"
GLYPHS = {
    "A": ["01110", "10001", "10001", "11111", "10001", "10001", "10001"],
    "D": ["11110", "10001", "10001", "10001", "10001", "10001", "11110"],
    "E": ["11111", "10000", "10000", "11110", "10000", "10000", "11111"],
    "I": ["11111", "00100", "00100", "00100", "00100", "00100", "11111"],
    "L": ["10000", "10000", "10000", "10000", "10000", "10000", "11111"],
    "N": ["10001", "11001", "11001", "10101", "10011", "10011", "10001"],
    "O": ["01110", "10001", "10001", "10001", "10001", "10001", "01110"],
    "S": ["01111", "10000", "10000", "01110", "00001", "00001", "11110"],
    "U": ["10001", "10001", "10001", "10001", "10001", "10001", "01110"],
    "V": ["10001", "10001", "10001", "10001", "10001", "01010", "00100"],
    "W": ["10001", "10001", "10001", "10101", "10101", "10101", "01010"],
    "4": ["00010", "00110", "01010", "10010", "11111", "00010", "00010"],
    "1": ["00100", "01100", "00100", "00100", "00100", "00100", "01110"],
    "-": ["00000", "00000", "00000", "11111", "00000", "00000", "00000"],
    ".": ["00000", "00000", "00000", "00000", "00000", "00100", "00100"],
}


class Canvas:
    def __init__(self, width, height, fonts, dark=False):
        self.width, self.height, self.fonts = width, height, fonts
        self.fg, self.bg = (WHITE, BLACK) if dark else (BLACK, WHITE)
        self.parts = [
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
            "<title>Dual-view on NOS 4.1. Independent Nothing Camera backport.</title>",
            f'<rect width="{width}" height="{height}" fill="{self.bg}"/>',
        ]

    def rect(self, x, y, w, h, fill, radius=0, stroke=None):
        self.parts.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{radius}" fill="{fill}"'
            + (f' stroke="{stroke}" stroke-width="2"' if stroke else "")
            + "/>"
        )

    def circle(self, x, y, radius, fill):
        self.parts.append(f'<circle cx="{x}" cy="{y}" r="{radius}" fill="{fill}"/>')

    def line(self, x1, y1, x2, y2, color=None, width=2):
        self.parts.append(
            f'<path d="M{x1},{y1} L{x2},{y2}" fill="none" stroke="{color or self.fg}" stroke-width="{width}"/>'
        )

    def text(self, value, x, y, size, color=None, weight=400):
        font = self.fonts[weight]
        glyphs, cmap = font.getGlyphSet(), font.getBestCmap()
        scale = size / font["head"].unitsPerEm
        cursor = 0
        for character in value:
            name = cmap.get(ord(character), ".notdef")
            pen = SVGPathPen(glyphs)
            glyphs[name].draw(pen)
            self.parts.append(
                f'<path d="{pen.getCommands()}" fill="{color or self.fg}" transform="translate({x + cursor * scale},{y}) scale({scale}, {-scale})"/>'
            )
            cursor += glyphs[name].width
        return cursor * scale

    def dots(self, value, x, y, step, color=None):
        for character in value:
            if character != " ":
                for row, cells in enumerate(GLYPHS[character]):
                    for col, cell in enumerate(cells):
                        if cell == "1":
                            self.circle(
                                x + col * step,
                                y + row * step,
                                step * 0.32,
                                color or self.fg,
                            )
            x += step * 6

    def capture(self, x, y, w, h):
        self.rect(x, y, w, h, BLACK, 38)
        self.rect(x + 18, y + 18, w - 36, h - 36, "#252525", 27)
        # The geometric views are illustrative, not captured device imagery.
        self.parts.append(
            f'<path d="M{x + 18},{y + h * 0.77} L{x + w * 0.40},{y + h * 0.30} L{x + w * 0.70},{y + h * 0.70} L{x + w - 18},{y + h * 0.43} V{y + h - 18} H{x + 18}Z" fill="#63645f"/>'
        )
        self.circle(x + w * 0.26, y + h * 0.27, w * 0.09, WHITE)
        px, py, pw, ph = x + w * 0.61, y + 35, w * 0.30, h * 0.35
        self.rect(px, py, pw, ph, WHITE, 18)
        self.circle(px + pw * 0.5, py + ph * 0.32, pw * 0.18, BLACK)
        self.parts.append(
            f'<path d="M{px + pw * 0.14},{py + ph * 0.84} Q{px + pw * 0.5},{py + ph * 0.38} {px + pw * 0.86},{py + ph * 0.84}" fill="{BLACK}"/>'
        )
        self.circle(x + 40, y + 45, 7, RED)
        self.text("REC", x + 56, y + 51, 18, WHITE, 600)
        self.rect(x + w * 0.33, y + h - 44, w * 0.34, 4, WHITE, 2)

    def footer(self, y, size=20):
        self.text("PHONE 3a  /  EXPERIMENTAL COMMUNITY PORT", 64, y, size, GRAY, 600)

    def save(self, name):
        svg = ROOT / "assets" / f"{name}.svg"
        svg.write_text("\n".join(self.parts + ["</svg>"]) + "\n")
        png = svg.with_suffix(".png")
        subprocess.run(["rsvg-convert", "-o", str(png), str(svg)], check=True)
        return {
            "name": name,
            "width": self.width,
            "height": self.height,
            "svg_sha256": hashlib.sha256(svg.read_bytes()).hexdigest(),
            "png_sha256": hashlib.sha256(png.read_bytes()).hexdigest(),
        }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--font", type=Path, required=True)
    args = parser.parse_args()
    fonts = {
        weight: instantiateVariableFont(
            TTFont(args.font), {"wght": weight}, inplace=False
        )
        for weight in (400, 600)
    }
    output = ROOT / "assets"
    output.mkdir(exist_ok=True)
    records = []

    c = Canvas(1600, 500, fonts)
    c.dots("DUAL-VIEW", 67, 102, 14)
    c.text("on NOS 4.1", 62, 294, 78, weight=600)
    c.text("Front + rear. One recording.", 66, 362, 30)
    c.footer(447)
    c.capture(1030, 35, 235, 430)
    c.text("Nothing Camera", 1310, 205, 23, weight=600)
    c.text("Backport", 1310, 239, 23, weight=600)
    c.circle(1318, 294, 6, RED)
    c.text("No OS upgrade", 1336, 301, 18)
    records.append(c.save("header"))

    c = Canvas(1600, 900, fonts, dark=True)
    c.dots("DUAL-VIEW", 70, 166, 17)
    c.text("on NOS 4.1", 63, 400, 100, weight=600)
    c.text("Both cameras.", 66, 515, 45)
    c.text("One moment.", 66, 575, 45)
    c.rect(65, 655, 372, 56, RED, 28)
    c.text("INSTALL THE BACKPORT", 91, 692, 23, WHITE, 600)
    c.footer(829, 22)
    c.capture(1030, 90, 405, 720)
    records.append(c.save("social-landscape"))

    c = Canvas(1080, 1920, fonts)
    c.dots("DUAL-VIEW", 71, 139, 17)
    c.text("on NOS 4.1", 65, 400, 104, weight=600)
    c.text("Front + rear. One recording.", 68, 487, 37)
    c.capture(266, 575, 548, 973)
    c.text("Keep your OS.", 66, 1670, 52, weight=600)
    c.text("Keep the factory Camera.", 66, 1740, 38)
    c.footer(1841, 22)
    records.append(c.save("social-portrait"))

    c = Canvas(1080, 1080, fonts, dark=True)
    c.dots("DUAL-VIEW", 62, 113, 15)
    c.text("on NOS 4.1", 58, 314, 83, weight=600)
    c.capture(675, 407, 287, 510)
    c.text("Front.", 62, 518, 62, weight=600)
    c.text("Rear.", 62, 602, 62, weight=600)
    c.text("Together.", 62, 686, 62, weight=600)
    c.text("Nothing Camera Backport", 62, 852, 28)
    c.footer(1007, 18)
    records.append(c.save("social-square"))

    c = Canvas(1600, 900, fonts)
    c.text("Install. Keep. Record.", 65, 145, 82, weight=600)
    rows = [
        ("1", "Install the APK", "Nothing Camera Beta Port"),
        ("2", "Keep the factory Camera", "It provides photo processing"),
        ("3", "Open Dual-view Video", "Front + rear with audio"),
    ]
    for index, (number, title, detail) in enumerate(rows):
        y = 292 + index * 167
        c.circle(103, y - 12, 34, RED)
        c.text(number, 91, y, 35, WHITE, 600)
        c.text(title, 169, y, 43, weight=600)
        c.text(detail, 171, y + 46, 27)
        c.line(169, y + 83, 938, y + 83, "#cfcdc5", 1)
    c.capture(1110, 225, 288, 510)
    c.footer(839)
    records.append(c.save("install-infographic"))

    c = Canvas(1600, 900, fonts, dark=True)
    c.text("New camera. Familiar engine.", 65, 139, 69, weight=600)
    c.text("The beta app uses your factory Camera's photo service.", 68, 215, 30)
    blocks = [
        (64, "Beta app", "NOS 5 camera frontend"),
        (577, "Adapter", "Translates the requests"),
        (1090, "Factory Camera", "NOS 4.1 processing"),
    ]
    for x, title, detail in blocks:
        c.rect(x, 355, 440, 208, "#222222", 22)
        c.text(title, x + 26, 443, 35, WHITE, 600)
        c.text(detail, x + 26, 496, 23, GRAY)
    for x in (518, 1031):
        c.line(x, 458, x + 42, 458, RED, 3)
        c.line(x + 42, 458, x + 31, 450, RED, 3)
        c.line(x + 42, 458, x + 31, 466, RED, 3)
    c.text("Separate app. Factory Camera stays enabled.", 68, 690, 37)
    c.footer(837)
    records.append(c.save("processing-infographic"))

    (output / "manifest.json").write_text(
        json.dumps(
            {
                "font": "Geist, SIL OFL 1.1",
                "font_sha256": hashlib.sha256(args.font.read_bytes()).hexdigest(),
                "renderer": "rsvg-convert; text converted to paths with fontTools",
                "artwork": "Original vector geometry; no captured user media",
                "files": records,
            },
            indent=2,
        )
        + "\n"
    )
    sheet = Image.new("RGB", (1200, 1200), "#d0cec6")
    draw = ImageDraw.Draw(sheet)
    for i, item in enumerate(records):
        image = Image.open(output / (item["name"] + ".png")).convert("RGB")
        thumb = ImageOps.contain(image, (560, 345))
        x, y = (i % 2) * 600 + 20, (i // 2) * 400 + 20
        sheet.paste(thumb, (x, y))
        draw.text((x, y + 360), item["name"], fill=BLACK)
    contact_sheet = ROOT / ".work" / "artwork-contact-sheet.png"
    contact_sheet.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(contact_sheet)
    print(f"Rendered {len(records)} SVG/PNG pairs")


if __name__ == "__main__":
    main()
