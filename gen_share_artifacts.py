#!/usr/bin/env python3
# 3C 配套：换新链接后重新生成分享产物（二维码 + 跨平台桌面快捷方式）
import os, textwrap
import qrcode
from qrcode.image.svg import SvgPathImage

ROOT = os.path.dirname(os.path.abspath(__file__))
SHARE = os.path.join(ROOT, "share")
os.makedirs(SHARE, exist_ok=True)

LINK = "https://95e9e5579f2a4eaaaa531d53d7aa96b4.app.workbuddy.link"
APP_NAME = "知鸟答案工作台"

# ---------- 1. 二维码 PNG ----------
qr = qrcode.QRCode(
    version=None,
    error_correction=qrcode.constants.ERROR_CORRECT_M,  # 中等容错，含图标也易扫
    box_size=12,
    border=4,
)
qr.add_data(LINK)
qr.make(fit=True)
img = qr.make_image(fill_color="#0a2540", back_color="white")
png_path = os.path.join(SHARE, "知鸟答案工作台-二维码.png")
img.save(png_path)
print("二维码 PNG:", png_path, os.path.getsize(png_path), "bytes")

# ---------- 2. 二维码 SVG ----------
qr_svg = qrcode.QRCode(
    error_correction=qrcode.constants.ERROR_CORRECT_M,
    box_size=12, border=4,
)
qr_svg.add_data(LINK)
qr_svg.make(fit=True)
svg_img = qr_svg.make_image(image_factory=SvgPathImage, fill_color="#0a2540", back_color="white")
svg_path = os.path.join(SHARE, "知鸟答案工作台-二维码.svg")
svg_img.save(svg_path)
print("二维码 SVG:", svg_path, os.path.getsize(svg_path), "bytes")

# ---------- 3. 桌面快捷方式（跨平台） ----------
# macOS .webloc
webloc = f"""<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>URL</key>
    <string>{LINK}</string>
</dict>
</plist>
"""
webloc_path = os.path.join(SHARE, f"{APP_NAME}.webloc")
with open(webloc_path, "w", encoding="utf-8") as f:
    f.write(webloc)
print("macOS 快捷方式:", webloc_path)

# Windows .url
url = f"[InternetShortcut]\nURL={LINK}\n"
url_path = os.path.join(SHARE, f"{APP_NAME}.url")
with open(url_path, "w", encoding="utf-8") as f:
    f.write(url)
print("Windows 快捷方式:", url_path)

# Linux .desktop
desktop = textwrap.dedent(f"""\
[Desktop Entry]
Version=1.0
Type=Application
Name={APP_NAME}
Comment=知鸟答案工作台：话术、演示、月考题库
Exec=xdg-open {LINK}
Terminal=false
Categories=Network;Utility;
""")
desktop_path = os.path.join(SHARE, f"{APP_NAME}.desktop")
with open(desktop_path, "w", encoding="utf-8") as f:
    f.write(desktop)
print("Linux 快捷方式:", desktop_path)

print("\n链接:", LINK)
print("分享产物目录:", SHARE)
