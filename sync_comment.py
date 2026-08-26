paths = [
  '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/知鸟答案工作台.html',
  '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/dist/index.html',
  '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/dist/index.static.html',
]
old = '/* 国补操作流程：用户指定使用 SF Symbols macbook.and.iphone 图标；20×20 */'
new = '/* 国补操作流程：用户指定 SF Symbols chineseyuanrenminbisign.arrow.trianglehead.counterclockwise.rotate.90（¥ + 逆时针旋转箭头）；20×20 */'
for fp in paths:
    with open(fp, 'r', encoding='utf-8') as f:
        s = f.read()
    assert s.count(old) == 1, f'{fp}: old comment count = {s.count(old)}'
    s = s.replace(old, new)
    with open(fp, 'w', encoding='utf-8') as f:
        f.write(s)
    print('OK  ', fp)
print('DONE')
