import re, pathlib, sys

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
SRC = ROOT / '知鸟答案工作台.html'
D1 = ROOT / 'dist/index.html'
D2 = ROOT / 'dist/index.static.html'

def swap_in_text(text: str, path: str) -> str:
    # 找到 <div class="section-tabs" id="sectionTabs"> ... </div> 里的 exam/aep 按钮并互换
    # 用正则提取 button 标签（含 SVG），要求 data-sec="exam" 或 "aep"
    pattern = re.compile(
        r'(<button\s+class="sec-tab"\s+data-sec="exam">.*?</svg>月考模式</button>)\s*'
        r'(<button\s+class="sec-tab"\s+data-sec="aep">.*?</svg>AEP周任务</button>)',
        re.DOTALL
    )
    m = pattern.search(text)
    if not m:
        # 也许顺序已经换过？检查反向
        pattern2 = re.compile(
            r'(<button\s+class="sec-tab"\s+data-sec="aep">.*?</svg>AEP周任务</button>)\s*'
            r'(<button\s+class="sec-tab"\s+data-sec="exam">.*?</svg>月考模式</button>)',
            re.DOTALL
        )
        m2 = pattern2.search(text)
        if m2:
            print(f'  {path}: already swapped (aep before exam)')
            return text
        raise ValueError(f'{path}: cannot find exam+aep tab buttons in expected order')
    new_text = text[:m.start()] + m.group(2) + '\n      ' + m.group(1) + text[m.end():]
    print(f'  {path}: swapped exam <-> aep')
    return new_text

def process(path: pathlib.Path):
    text = path.read_text(encoding='utf-8')
    new_text = swap_in_text(text, str(path))
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        print(f'  {path}: written')
    else:
        print(f'  {path}: unchanged')

for p in [SRC, D1, D2]:
    print(f'Processing {p} ...')
    process(p)

print('Done.')
