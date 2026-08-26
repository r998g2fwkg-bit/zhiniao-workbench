#!/usr/bin/env python3
# 三端同步：为 AEP Tab 补上 --tab-accent 品牌色声明，使图标变绿
import io, sys

FILES = [
    "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/知鸟答案工作台.html",
    "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/dist/index.html",
    "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/dist/index.static.html",
]

OLD = '.sec-tab[data-sec="exam"]{--tab-accent:var(--exam-accent)}\n'
NEW = ('.sec-tab[data-sec="exam"]{--tab-accent:var(--exam-accent)}\n'
       '.sec-tab[data-sec="aep"]{--tab-accent:var(--aep-accent)}\n')

for fp in FILES:
    with open(fp, "r", encoding="utf-8") as f:
        s = f.read()
    n = s.count(OLD)
    if n == 0:
        # 已存在 AEP 行则跳过，否则报错
        assert '.sec-tab[data-sec="aep"]{--tab-accent:var(--aep-accent)}' in s, \
            f"{fp}: 既无 exam 行也无 aep 行，状态异常"
        print("OK (已含AEP行,跳过) ", fp)
        continue
    s = s.replace(OLD, NEW, 1)
    with open(fp, "w", encoding="utf-8") as f:
        f.write(s)
    print(f"应用 {n} 处 -> ", fp)

# 断言三端均含 AEP 品牌色行
for fp in FILES:
    with open(fp, "r", encoding="utf-8") as f:
        s = f.read()
    assert '.sec-tab[data-sec="aep"]{--tab-accent:var(--aep-accent)}' in s, \
        f"{fp}: 缺少 AEP 品牌色声明"
    # 确保不会重复出现
    assert s.count('.sec-tab[data-sec="aep"]{--tab-accent:var(--aep-accent)}') == 1, \
        f"{fp}: AEP 品牌色行重复"
print("\n全部三端一致，AEP 图标已上色。")
