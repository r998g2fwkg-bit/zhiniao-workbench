import re, pathlib, subprocess, sys

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = ['知鸟答案工作台.html', 'dist/index.html', 'dist/index.static.html']

for f in FILES:
    html = (ROOT/f).read_text(encoding='utf-8')

    # Q4W8 正确范围
    assert '8月16日–8月22日' in html, f'{f}: Q4W8 range wrong'
    assert "dateRange:'8月16日–8月22日'" in html, f'{f}: Q4W8 dateRange wrong'
    assert "startDate:'2026-08-16'" in html, f'{f}: Q4W8 startDate wrong'

    # HTML 初始值
    assert '<span class="aep-week-range" id="aepWeekRange">8月16日–8月22日</span>' in html, f'{f}: HTML init wrong'

    # Q4W9 对齐
    assert "dateRange:'8月23日–8月29日'" in html, f'{f}: Q4W9 range wrong'
    assert "startDate:'2026-08-23'" in html, f'{f}: Q4W9 startDate wrong'

    # 旧值已不存在
    assert '8月17日–8月23日' not in html, f'{f}: old Q4W8 still present'
    assert '8月24日–8月30日' not in html, f'{f}: old Q4W9 still present'
    assert "startDate:'2026-08-17'" not in html, f'{f}: old startDate present'

    print(f'{f}: OK')

print('All AEP week-range checks passed.')
