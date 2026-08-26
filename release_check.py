#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
知鸟答案工作台 · 发布前自动校验门禁 (release_check.py)
整合此前散落的断言，部署前运行一次即可确认三端一致、关键功能无回归。
用法: python3 release_check.py
退出码: 0=通过, 1=存在失败项
"""
import os, re, subprocess, sys, tempfile

ROOT = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01'
FILES = ['知鸟答案工作台.html', 'dist/index.html', 'dist/index.static.html']
NODE = '/Users/zhoujiale/.workbuddy/binaries/node/versions/22.12.0/bin/node'

failures = []
def check(cond, msg):
    if cond:
        print(f"  [OK] {msg}")
    else:
        print(f"  [FAIL] {msg}")
        failures.append(msg)

def read(f):
    return open(os.path.join(ROOT, f), 'r', encoding='utf-8').read()

print("=== 知鸟答案工作台 发布前校验 ===\n")

texts = {f: read(f) for f in FILES}

# 1. Tab 顺序 (sectionTabs 内 data-sec 顺序)
print("[1] 顶部 Tab 顺序")
for f in FILES:
    m = re.search(r'<div class="section-tabs" id="sectionTabs">(.*?)</div>', texts[f], re.S)
    secs = re.findall(r'data-sec="([^"]+)"', m.group(1)) if m else []
    check(secs == ['script', 'demo', 'aep', 'exam', 'hours'], f"{f}: Tab 顺序 = {','.join(secs)}")

# 2. AEP 周任务日期范围 (周日–周六)
print("\n[2] AEP 周任务日期范围 (周日起算)")
for f in FILES:
    t = texts[f]
    check('8月16日–8月22日' in t, f"{f}: Q4W8 = 8月16日–8月22日 (周日–周六)")
    check('8月17日–8月23日' not in t, f"{f}: 旧 Q4W8(8月17-23) 已移除")
    check('8月23日–8月29日' in t, f"{f}: Q4W9 = 8月23日–8月29日")
    check('8月24日–8月30日' not in t, f"{f}: 旧 Q4W9(8月24-30) 已移除")
    check('"startDate": "2026-08-16"' in t, f"{f}: Q4W8 startDate=2026-08-16")
    check('"startDate": "2026-08-23"' in t, f"{f}: Q4W9 startDate=2026-08-23")

# 3. 统计卡「新上架」口径 = 显式 NEWLY_ADDED 清单
print("\n[3] 统计卡「新上架」清单")
for f in FILES:
    t = texts[f]
    check("NEWLY_ADDED.includes" in t, f"{f}: NEWLY_ADDED 过滤逻辑存在")
    check("const NEWLY_ADDED = window.__APP_DATA__.NEWLY_ADDED||[];" in t, f"{f}: NEWLY_ADDED 常量注入")
    check("let newOnly=false;" in t, f"{f}: newOnly 状态变量")
    check('id="statNew"' in t, f"{f}: 统计卡 id=statNew")
    check("function toggleNewOnly" in t, f"{f}: toggleNewOnly 函数存在")
    check('新增（7天）' not in t and 'cutoff.setDate(cutoff.getDate()-7)' not in t, f"{f}: 旧 7 天口径已移除")

# 4. 测试账户改名 + 类型标识
print("\n[4] 测试账户 (rikchou) 改名 + 类型标识")
for f in FILES:
    t = texts[f]
    check("'rikchou@icloud.com':'Onezero长沙河西王府井店'" in t, f"{f}: 显示名=Onezero长沙河西王府井店")
    check("'测试账号'" not in t and '"测试账号"' not in t, f"{f}: 用户可见「测试账号」文案已移除")
    check('id="accountType"' in t, f"{f}: 账户类型 span 存在")
    check('.account-type{' in t, f"{f}: 类型药丸 CSS 存在")
    check('isTest=SALARY_HIDDEN_EMAILS' in t, f"{f}: 类型判定逻辑存在")

# 5. 头像点击强制刷新
print("\n[5] 头像点击强制刷新")
for f in FILES:
    check('onclick="location.reload(true)"' in t if False else 'onclick="location.reload(true)"' in texts[f],
          f"{f}: 头像 onclick=location.reload(true)")

# 6. 头像资源完整性 (USER_AVATARS 引用的文件在 source 与 dist 均存在)
print("\n[6] 头像资源完整性")
for f in FILES:
    base = ROOT if f == '知鸟答案工作台.html' else os.path.join(ROOT, 'dist')
    m = re.search(r'USER_AVATARS=\{(.*?)\};', texts[f], re.S)
    avs = re.findall(r"'([^']*?)':'(assets/avatars/[^']+?)'", m.group(1)) if m else []
    for email, rel in avs:
        p = os.path.join(base, rel)
        check(os.path.isfile(p), f"{f}: 头像存在 {rel} ({email})")

# 7. 三端关键内容一致性
print("\n[7] 三端关键内容一致性")
probes = [
    "8月16日–8月22日",
    'id="statNew"',
    "'rikchou@icloud.com':'Onezero长沙河西王府井店'",
    "id=\"accountType\"",
    "SALARY_HIDDEN_EMAILS = window.__APP_DATA__.SALARY_HIDDEN_EMAILS",
]
for p in probes:
    counts = [texts[f].count(p) for f in FILES]
    check(len(set(counts)) == 1 and counts[0] > 0, f"三端一致: 「{p}」 出现次数={counts}")

# 8. JS 语法检查 (内联脚本 node --check)
print("\n[8] JS 语法检查 (内联脚本)")
for f in FILES:
    html = texts[f]
    scripts = re.findall(r'<script>(.*?)</script>', html, re.S)
    scripts = [s for s in scripts if s.strip()]
    ok = True
    for i, s in enumerate(scripts):
        with tempfile.NamedTemporaryFile('w', suffix='.js', delete=False, encoding='utf-8') as tf:
            tf.write(s); tmp = tf.name
        r = subprocess.run([NODE, '--check', tmp], capture_output=True, text=True)
        os.unlink(tmp)
        if r.returncode != 0:
            ok = False
            failures.append(f"{f}: 内联脚本#{i} 语法错误: {r.stderr.strip().splitlines()[-1]}")
            print(f"  [FAIL] {f}: 内联脚本#{i} 语法错误")
    if ok:
        print(f"  [OK] {f}: {len(scripts)} 个内联脚本语法 OK")

# 9. 待补清单导出格式 (B: 跨店汇总闭环)
print("\n[9] 待补清单导出格式 (结构化 JSON, 含门店/月份)")
for f in FILES:
    t = texts[f]
    check('导出汇总(.json)' in t, f"{f}: 导出按钮=导出汇总(.json)")
    check("'待补清单_'+store+'_'+month+'.json'" in t, f"{f}: 文件名含门店+月份")
    check("tool:'zhiniao-exam-gaps'" in t, f"{f}: payload 带工具标识")
    check("loadExamHits().filter(function(h){ return h.month===month; })" in t, f"{f}: 导出含本月命中")
    check("'待补清单_'+s.month+'.txt'" not in t, f"{f}: 旧 .txt 导出已移除")

# 10. P1④ 命中增强（置信度 + 标题高亮 + 近似候选）
print("\n[10] P1④ 命中增强 (置信度徽章 / 标题高亮 / 近似候选)")
for f in FILES:
    t = texts[f]
    check("function examConfBadge(score)" in t, f"{f}: 置信度徽章函数存在")
    check("function examHighlightTitleFrag(normQ, title)" in t, f"{f}: 标题高亮函数存在")
    check("function examCandidateList(pool, normQ, type, bestKey, k)" in t, f"{f}: 近似候选函数存在")
    check("examCandHTML(q)" in t, f"{f}: 候选渲染已接入卡片")
    check(".exam-conf.exact{color:#1a7f37" in t, f"{f}: 置信度样式存在")
    check("examHighlightTitleFrag(q.normQ, g.topic)" in t, f"{f}: 话术标题高亮已接入")
    check("examHighlightTitleFrag(q.normQ, e.topic)" in t, f"{f}: 演示标题高亮已接入")

# 11. P0② 最近更新变更日志
print("\n[11] P0② 最近更新变更日志")
for f in FILES:
    t = texts[f]
    check("const CHANGELOG = window.__APP_DATA__.CHANGELOG;" in t, f"{f}: CHANGELOG 常量存在(已抽离)")
    check("function renderChangelogInPanel(p){" in t, f"{f}: 更新日志面板渲染函数存在(消息中心)")
    check("var noticePanelTab=" in t, f"{f}: 消息中心双标签状态存在")
    check('id="changelog"' not in t, f"{f}: 概览区独立卡片已移除(合并入消息中心)")
    check("NOTICE_TTL_DAYS" in t and "function isNoticeActive(" in t, f"{f}: 通知时效判定存在(3天转历史)")
    check(".ov-changelog{margin:14px 0 4px" in t, f"{f}: 样式存在(保留兼容)")

# 12. P1⑤ 全量备份 / 一键恢复 / 滚动快照
print("\n[12] P1⑤ 全量备份 / 一键恢复 / 滚动快照")
for f in FILES:
    t = texts[f]
    check("const K_BACKUPS='wb_zhiniao_backups'" in t, f"{f}: 快照键存在")
    check("function collectAllState()" in t, f"{f}: 全量采集函数存在")
    check("function backupAll(download)" in t, f"{f}: 全量备份函数存在")
    check("function importJSON(file)" in t, f"{f}: 一键恢复函数存在")
    check("function rollingSnapshot()" in t, f"{f}: 滚动快照函数存在")
    check("function restoreSnapshot(idx)" in t, f"{f}: 快照恢复函数存在")
    check("function autoBackupMaybe()" in t, f"{f}: 自动备份函数存在")
    check("function initAutoBackup()" in t, f"{f}: 启动钩子存在")
    check("id=\"btnRestoreSnap\"" in t, f"{f}: 恢复快照按钮存在")
    check("id=\"autoBackupChk\"" in t, f"{f}: 自动备份开关存在")
    check(".backup-auto{" in t, f"{f}: 自动备份样式存在")
    check("恢复最近快照" in t, f"{f}: 按钮文案存在")
    check("每周自动下载备份" in t, f"{f}: 开关文案存在")
    check("document.getElementById('btnRestoreSnap').onclick=()=>restoreSnapshot()" in t, f"{f}: 恢复按钮已绑定")
    check("render();\nrenderTabBadges();\ninitAutoBackup();" in t, f"{f}: 启动已挂 renderTabBadges+initAutoBackup")
    check("action:()=>backupAll(true)" in t, f"{f}: 命令面板已改调 backupAll")
    check("数据已积累 30 条以上，可点左侧" in t, f"{f}: 备份提醒文案已更新")

# 13. P2⑦ 语音兜底 + 检索容错
print("\n[13] P2⑦ 语音兜底 + 检索容错")
for f in FILES:
    t = texts[f]
    check("function speechHasZh()" in t, f"{f}: 中文语音检测函数存在")
    check("function speechWarnNoZh()" in t, f"{f}: 无语音警告函数存在")
    check("function normalizeSearch(s)" in t, f"{f}: 检索引擎归一化函数存在")
    check("function searchHit(haystack, query)" in t, f"{f}: 检索容错函数存在")
    check("speechWarnNoZh();" in t, f"{f}: initSpeech 已评估中文语音")
    check("voiceschanged=()=>{ voices=getVoicesSafe(); populateVoiceSelect(); speechWarnNoZh(); }" in t, f"{f}: onvoiceschanged 已评估")
    check("设备未安装中文语音，朗读可能无声或失真" in t, f"{f}: 朗读兜底提示文案存在")
    check("st.classList.add('no-zh')" in t, f"{f}: 警告加 no-zh 样式")
    check(".speech-bar .speech-status.no-zh{color:#c2410c}" in t, f"{f}: 无语音状态色存在")
    check("searchHit((x.topic+x.question+x.answer+x.keywords+x.sheet+x.category), q)" in t, f"{f}: 检索①已接容错")
    check("searchHit((x.topic+x.question+x.answer+x.keywords), q)" in t, f"{f}: 检索②已接容错")
    check("searchHit((x.topic+' '+x.intro+' '+x.sheet+' '+(x.category||'')), q)" in t, f"{f}: 检索③已接容错")
    check("const err = (ev&&ev.error)||'';" in t, f"{f}: onerror 错误名提取已接入")

# 14. P3⑨ 覆盖率看板
print("\n[14] P3⑨ 覆盖率看板（本机沉淀聚合）")
for f in FILES:
    t = texts[f]
    check("function renderExamCoverage(){" in t, f"{f}: 覆盖率看板函数存在")
    check("renderExamHitLog(); renderExamCoverage();" in t, f"{f}: 调用点已接入")
    check('id="examCoverage"' in t, f"{f}: 容器存在")
    check("累计命中率" in t, f"{f}: 累计命中率文案")
    check("各月命中率" in t, f"{f}: 各月区块")
    check("盲区 Top（待补频次）" in t, f"{f}: 盲区 Top")
    check("命中热度 Top" in t, f"{f}: 命中热度 Top")
    check(".cov-grid{display:grid" in t, f"{f}: 看板栅格样式")
    check("本机暂无月考记录" in t, f"{f}: 空态提示")

# 15. 3C 数据抽离完整性（JSON 真源 + 三端无残留 + 数据 blob 一致）
print("\n[15] 3C 数据抽离完整性")
import json as _json, re as _re
try:
    with open(os.path.join(ROOT, 'data', 'app_data.json'), 'r', encoding='utf-8') as _f:
        _ad = _json.load(_f)
    check(True, "data/app_data.json 可解析")
    _raw_n = len(_ad.get('RAW_DATA', []))
except Exception as e:
    _raw_n = -1
    check(False, f"data/app_data.json 解析失败: {e}")
for f in FILES:
    check("__APP_DATA_JSON__" not in texts[f], f"{f}: 无残留注入占位符")
    t = texts[f]
    check("window.__APP_DATA__ = {" in t, f"{f}: 含数据注入点")
    check("const RAW_DATA = window.__APP_DATA__.RAW_DATA;" in t, f"{f}: RAW_DATA 引用声明")
    check("const CHANGELOG = window.__APP_DATA__.CHANGELOG;" in t, f"{f}: CHANGELOG 引用声明")
_blobs = set()
for f in FILES:
    m = _re.search(r'window\.__APP_DATA__\s*=\s*(.*?);\s*</script>', texts[f], _re.S)
    check(m is not None, f"{f}: 可定位数据 blob")
    if m:
        try:
            _rep = _json.loads(m.group(1).replace('<\\/', '</'))
            _blobs.add(m.group(1))
            check(len(_rep.get('RAW_DATA', [])) == _raw_n and _raw_n >= 0,
                  f"{f}: RAW_DATA 计数与真源一致 ({_raw_n})")
        except Exception as e:
            check(False, f"{f}: 数据 blob 解析失败: {e}")
check(len(_blobs) == 1, f"三端数据 blob 完全一致 (哈希数={len(_blobs)})")

# 汇总
print("\n=== 校验汇总 ===")
if failures:
    print(f"❌ 未通过 {len(failures)} 项：")
    for x in failures:
        print(f"   - {x}")
    sys.exit(1)
else:
    print("✅ 全部通过，可以部署。")
    sys.exit(0)
