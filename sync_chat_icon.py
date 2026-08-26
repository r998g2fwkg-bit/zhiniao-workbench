import re

paths = [
    '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/知鸟答案工作台.html',
    '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/dist/index.html',
    '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/dist/index.static.html',
]

# Extract the two bubble paths from the Ai Coach tab in the source file
src = open(paths[0], encoding='utf-8').read()
m = re.search(r'<button class="sec-tab active" data-sec="script"><svg class="tab-icon" width="20" height="20" viewBox="0 0 35\.5469 28\.1543" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round" stroke-linecap="round">(.*?)</svg>', src, re.S)
assert m, 'Ai Coach tab SVG not found'
paths_svg = m.group(1).strip()

# New ICON_CHAT: same paths, but 16x16 (used in stats card and exam labels)
new_icon_chat = f"const ICON_CHAT='<svg width=\"16\" height=\"16\" viewBox=\"0 0 35.5469 28.1543\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linejoin=\"round\" stroke-linecap=\"round\">{paths_svg}</svg>';"

# Old ICON_CHAT pattern
old_icon_chat_re = re.compile(r'const ICON_CHAT=\'<svg width="16" height="16" viewBox="0 0 24 24"[^>]*>.*?</svg>\';', re.S)

for fp in paths:
    with open(fp, 'r', encoding='utf-8') as f:
        s = f.read()
    c = len(old_icon_chat_re.findall(s))
    assert c == 1, f'{fp}: old ICON_CHAT count = {c} (expected 1)'
    s = old_icon_chat_re.sub(new_icon_chat, s)
    with open(fp, 'w', encoding='utf-8') as f:
        f.write(s)
    # sanity
    assert 'const ICON_CHAT=\'<svg width="16" height="16" viewBox="0 0 35.5469 28.1543"' in s
    assert 'const ICON_CHAT=\'<svg width="16" height="16" viewBox="0 0 24 24"' not in s
    print('OK ', fp)

print('ALL DONE')
