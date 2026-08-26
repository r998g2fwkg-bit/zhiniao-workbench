import re, pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

def update(path):
    text = path.read_text(encoding='utf-8')
    orig = text

    # 1. 删除待补清单 summary 中的提示文案
    text = text.replace(
        '待补清单（匹配不到的题，可复制发给 Rik 烘焙进题库）',
        '待补清单'
    )

    # 2. 统计卡 cutoff 从 15 天改为 7 天
    text = text.replace(
        'cutoff.setDate(cutoff.getDate()-15)',
        'cutoff.setDate(cutoff.getDate()-7)'
    )

    # 3. label / title 文案从 15 天改为 7 天
    text = text.replace('新增（15天）', '新增（7天）')
    text = text.replace('15天内新增的主题', '7天内新增的主题')
    # Demo 的 title 也可同步
    text = text.replace('title="Ai Demo 暂无新增时间追踪"', 'title="Ai Demo 暂无新增时间追踪"')

    if text != orig:
        path.write_text(text, encoding='utf-8')
        print(f'  {path}: updated')
    else:
        print(f'  {path}: unchanged')

for p in FILES:
    print(f'Processing {p} ...')
    update(p)

print('Done.')
