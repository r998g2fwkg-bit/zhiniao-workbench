#!/usr/bin/env python3
# 把「覆盖率看板」「最近更新」改为仅管理员可见（三端同步）
import io, sys

FILES = [
    "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/知鸟答案工作台.html",
    "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/dist/index.html",
    "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/dist/index.static.html",
]

REPLS = [
    # 1) CSS：admin-only 默认隐藏，admin 时通用规则强制 flex 会破坏块级布局，加针对性 block 覆盖
    (
        ".admin-only{display:none !important}\nbody.is-admin .admin-only{display:flex !important}",
        ".admin-only{display:none !important}\nbody.is-admin .admin-only{display:flex !important}\n"
        "body.is-admin #changelog.admin-only{display:block !important}\n"
        "body.is-admin .exam-hitlog.admin-only{display:block !important}"
    ),
    # 2) 最近更新 容器加 admin-only
    (
        '    <div id="changelog" class="ov-changelog"></div>',
        '    <div id="changelog" class="ov-changelog admin-only"></div>'
    ),
    # 3) 覆盖率看板 容器加 admin-only
    (
        '      <div class="exam-hitlog" id="examCoverage"></div>',
        '      <div class="exam-hitlog admin-only" id="examCoverage"></div>'
    ),
    # 4) renderChangelog 守卫
    (
        "function renderChangelog(){\n  const box=document.getElementById('changelog'); if(!box) return;",
        "function renderChangelog(){\n  const box=document.getElementById('changelog'); if(!box) return;\n"
        "  if(!isAdmin()){ box.style.display='none'; return; }"
    ),
    # 5) renderExamCoverage 守卫
    (
        "function renderExamCoverage(){\n  const box=document.getElementById('examCoverage'); if(!box) return;",
        "function renderExamCoverage(){\n  const box=document.getElementById('examCoverage'); if(!box) return;\n"
        "  if(!isAdmin()){ box.style.display='none'; return; }"
    ),
]

for f in FILES:
    with io.open(f, "r", encoding="utf-8") as fh:
        s = fh.read()
    for i, (old, new) in enumerate(REPLS, 1):
        cnt = s.count(old)
        if cnt != 1:
            raise SystemExit("FAIL %s repl#%d count=%d" % (f, i, cnt))
        s = s.replace(old, new, 1)
    with io.open(f, "w", encoding="utf-8") as fh:
        fh.write(s)
    print("OK  ", f)
print("ALL DONE")
