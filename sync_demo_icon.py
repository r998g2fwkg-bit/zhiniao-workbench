#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""三端同步：Ai Demo Tab + 统计卡图标统一为 bubble.left.and.text.bubble.right"""
import re, pathlib, sys

ROOT = pathlib.Path("/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01")
FILES = [
    ROOT / "知鸟答案工作台.html",
    ROOT / "dist" / "index.html",
    ROOT / "dist" / "index.static.html",
]

BUBBLE_20 = (
    '<svg class="tab-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">'
    '<path d="M4.5 14.5V6.5C4.5 5.4 5.4 4.5 6.5 4.5H13C14.1 4.5 15 5.4 15 6.5V11C15 12.1 14.1 13 13 13H10.5L7.5 16V13H6.5C5.4 13 4.5 12.1 4.5 11Z"/>'
    '<path d="M12 19V14C12 12.9 12.9 12 14 12H19.5C20.6 12 21.5 12.9 21.5 14V17C21.5 18.1 20.6 19 19.5 19H18.5L16.5 21V19H14C12.9 19 12 18.1 12 17Z"/>'
    '<line x1="14.5" y1="14.5" x2="19" y2="14.5"/>'
    '<line x1="14.5" y1="16.5" x2="18" y2="16.5"/>'
    '</svg>'
)

BUBBLE_16 = (
    '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">'
    '<path d="M4.5 14.5V6.5C4.5 5.4 5.4 4.5 6.5 4.5H13C14.1 4.5 15 5.4 15 6.5V11C15 12.1 14.1 13 13 13H10.5L7.5 16V13H6.5C5.4 13 4.5 12.1 4.5 11Z"/>'
    '<path d="M12 19V14C12 12.9 12.9 12 14 12H19.5C20.6 12 21.5 12.9 21.5 14V17C21.5 18.1 20.6 19 19.5 19H18.5L16.5 21V19H14C12.9 19 12 18.1 12 17Z"/>'
    '<line x1="14.5" y1="14.5" x2="19" y2="14.5"/>'
    '<line x1="14.5" y1="16.5" x2="18" y2="16.5"/>'
    '</svg>'
)

TAB_OLD_RE = re.compile(
    r'<button class="sec-tab" data-sec="demo"><svg class="tab-icon" width="20" height="20" viewBox="0 0 23\.7598 31\.1621"[^>]*>.*?</svg>Ai Demo</button>',
    re.S
)
TAB_NEW = f'<button class="sec-tab" data-sec="demo">{BUBBLE_20}Ai Demo</button>'

STAT_OLD_RE = re.compile(
    r'<span class="ov-ic">\$\{ICON_PLAY\}</span><span class="num">\$\{topics\}</span><span class="label">演示主题</span>'
)
STAT_NEW = f'<span class="ov-ic">{BUBBLE_16}</span><span class="num">${{topics}}</span><span class="label">演示主题</span>'

all_ok = True
for f in FILES:
    text = f.read_text(encoding="utf-8")
    before = text

    text, n_tab = TAB_OLD_RE.subn(TAB_NEW, text)
    text, n_stat = STAT_OLD_RE.subn(STAT_NEW, text)

    print(f"{f.name}: tab={n_tab}, stat={n_stat}")

    # 断言
    assert n_tab == 1, f"{f.name}: 期望替换 1 处 Tab 图标，实际 {n_tab}"
    assert n_stat == 1, f"{f.name}: 期望替换 1 处统计卡图标，实际 {n_stat}"

    # 替换后不应再出现旧的 hand.tap viewBox
    assert 'viewBox="0 0 23.7598 31.1621"' not in text, f"{f.name}: 仍有 hand.tap viewBox 残留"

    # 不应影响月考标签里的 ICON_PLAY
    assert '${ICON_PLAY}演示' in text, f"{f.name}: 月考标签里的 ICON_PLAY 被误伤"
    assert '<span>' + '${ICON_PLAY}' + '演示' in text or '${ICON_PLAY}演示' in text, f"{f.name}: 月考统计 pill 里的 ICON_PLAY 可能被误伤"

    if text != before:
        f.write_text(text, encoding="utf-8")
        print(f"  -> 已写入")
    else:
        print(f"  -> 无变化")

print("三端同步完成")
