import pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

# 替换表：(old, new) —— 周日至周六对齐
REPL = [
    # Q4W8: HTML 初始值 + 常量 dateRange + startDate
    ('<span class="aep-week-range" id="aepWeekRange">8月17日–8月23日</span>',
     '<span class="aep-week-range" id="aepWeekRange">8月16日–8月22日</span>'),
    ("dateRange:'8月17日–8月23日'",
     "dateRange:'8月16日–8月22日'"),
    ("startDate:'2026-08-17'",
     "startDate:'2026-08-16'"),
    # Q4W9: 周日至周六对齐（8月23日周日 - 8月29日周六）
    ("dateRange:'8月24日–8月30日'",
     "dateRange:'8月23日–8月29日'"),
    ("startDate:'2026-08-24'",
     "startDate:'2026-08-23'"),
]

for p in FILES:
    text = p.read_text(encoding='utf-8')
    orig = text
    for old, new in REPL:
        if old not in text:
            print(f'  {p}: WARN not found: {old[:40]!r}')
        text = text.replace(old, new)
    if text != orig:
        p.write_text(text, encoding='utf-8')
        print(f'  {p}: updated')
    else:
        print(f'  {p}: unchanged')

print('Done.')
