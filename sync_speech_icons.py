#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""三端同步：语音条 play.circle / pause.circle / stop.circle / waveform 图标替换。
源文件（知鸟答案工作台.html）已手工改好，本脚本以源为准，把对应区块拷进两个 dist 文件。
策略：从源提取 NEW 区块，在 dist 中用相同的正则匹配到旧区块并整体替换，保证三端一致。"""
import os, re, sys

BASE = "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01"
SRC = os.path.join(BASE, "知鸟答案工作台.html")
DIST = [os.path.join(BASE, "dist", "index.html"), os.path.join(BASE, "dist", "index.static.html")]

src = open(SRC, encoding="utf-8").read()

# 1) 提取源中各 NEW 区块
def extract(pattern, name):
    m = re.search(pattern, src, re.S)
    if not m:
        print("  !! 源中未找到 %s" % name); sys.exit(1)
    return m.group(0)

new_speech_icon = extract(r'        <div class="speech-icon" aria-hidden="true">.*?        </div>', "speech-icon")
new_speech_toggle = extract(r'        <button class="btn btn-icon" id="speechToggle".*?        </button>', "speechToggle")
new_speech_stop = extract(r'        <button class="btn btn-icon" id="speechStop".*?        </button>', "speechStop")
new_update_fn = extract(r'(?s)function updateSpeechToggle\(\)\{.*?\n\}', "updateSpeechToggle")

# 2) 在 dist 中替换（用与源相同的正则定位旧区块）
for f in DIST:
    if not os.path.exists(f):
        print("SKIP (missing):", f); continue
    s = open(f, encoding="utf-8").read()
    reps = 0
    # P1 speech-icon
    s, n = re.subn(r'        <div class="speech-icon" aria-hidden="true">.*?        </div>', new_speech_icon, s, count=1, flags=re.S)
    reps += n
    # P2 speechToggle
    s, n = re.subn(r'        <button class="btn btn-icon" id="speechToggle".*?        </button>', new_speech_toggle, s, count=1, flags=re.S)
    reps += n
    # P3 speechStop
    s, n = re.subn(r'        <button class="btn btn-icon" id="speechStop".*?        </button>', new_speech_stop, s, count=1, flags=re.S)
    reps += n
    # P4 drawerSpeechToggleIcon svg 属性补齐 stroke
    old_drawer = '<svg id="drawerSpeechToggleIcon" width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><rect x="6" y="4" width="4" height="16"></rect><rect x="14" y="4" width="4" height="16"></rect></svg>'
    new_drawer = '<svg id="drawerSpeechToggleIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="6" y="4" width="4" height="16"></rect><rect x="14" y="4" width="4" height="16"></rect></svg>'
    if old_drawer in s:
        s = s.replace(old_drawer, new_drawer, 1); reps += 1
    elif new_drawer not in s:
        print("  !! %s 中 drawerSpeechToggleIcon 既无旧也无新" % f); sys.exit(1)
    # P5 updateSpeechToggle JS
    s, n = re.subn(r'(?s)function updateSpeechToggle\(\)\{.*?\n\}', new_update_fn, s, count=1)
    reps += n
    if reps != 5:
        print("  !! %s 替换数=%d（期望5）" % (f, reps)); sys.exit(1)
    open(f, "w", encoding="utf-8").write(s)
    print("OK  %s  reps=%d" % (f, reps))

print("DONE")
