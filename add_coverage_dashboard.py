#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""三端同步：P3⑨ 覆盖率看板（本机沉淀的命中/待补数据聚合）。"""
import pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

# 1. 容器：在 #examHitLog 后插入 #examCoverage
CONT_OLD = '<div class="exam-hitlog" id="examHitLog"></div>'
CONT_NEW = '<div class="exam-hitlog" id="examHitLog"></div>\n      <div class="exam-hitlog" id="examCoverage"></div>'

# 2. 调用点：所有 renderExamHitLog(); -> 追加 renderExamCoverage();
CALL_OLD = 'renderExamHitLog();'
CALL_NEW = 'renderExamHitLog(); renderExamCoverage();'

# 3. 函数：在 renderExamHitLog 定义结束后插入 renderExamCoverage
FUNC_ANCHOR = "  const exp=document.getElementById('examExportGaps');\n  if(exp) exp.onclick=function(){"
FUNC_INSERT = """  const exp=document.getElementById('examExportGaps');
  if(exp) exp.onclick=function(){
/** 覆盖率看板：基于本机沉淀的命中/待补数据，展示题库对真实月考的覆盖情况。 */
function renderExamCoverage(){
  const box=document.getElementById('examCoverage'); if(!box) return;
  const hits=loadExamHits(), gaps=loadExamGaps();
  const totalAll=hits.length+gaps.length;
  const rateAll= totalAll? Math.round(hits.length/totalAll*100):0;
  const months={};
  hits.forEach(function(h){ (months[h.month]=months[h.month]||{h:0,g:0}).h++; });
  gaps.forEach(function(g){ (months[g.month]=months[g.month]||{h:0,g:0}).g++; });
  const monthRows=Object.keys(months).sort().reverse().slice(0,6).map(function(m){
    const o=months[m]; const t=o.h+o.g; const r=t?Math.round(o.h/t*100):0;
    return '<div class="cov-row"><span class="cov-m">'+esc(m)+'</span><span class="cov-r">'+r+'%</span><span class="cov-n">'+t+' 题</span></div>';
  }).join('');
  const gapCount={};
  gaps.forEach(function(g){ const k=g.key||examNorm(g.q)||g.q; gapCount[k]=(gapCount[k]||0)+1; });
  const gapTop=Object.keys(gapCount).sort(function(a,b){ return gapCount[b]-gapCount[a]; }).slice(0,5)
    .map(function(k){ const sample=gaps.find(function(g){ return (g.key||examNorm(g.q)||g.q)===k; }); return '<li>'+esc(sample?sample.q:k)+'<span class="cov-c">'+gapCount[k]+' 次</span></li>'; }).join('');
  const hitCount={};
  hits.forEach(function(h){ const k=(h.sheet||'')+'||'+(h.topic||''); hitCount[k]=(hitCount[k]||0)+1; });
  const hitTop=Object.keys(hitCount).sort(function(a,b){ return hitCount[b]-hitCount[a]; }).slice(0,5)
    .map(function(k){ const t=k.split('||')[1]||k; return '<li>'+esc(t)+'<span class="cov-c">'+hitCount[k]+' 次</span></li>'; }).join('');
  if(!totalAll){
    box.innerHTML='<div class="exam-hitlog-head"><span class="exam-hitlog-title">\\u{1F4CA} 覆盖率看板（本机）</span></div>'
      +'<div class="exam-gaps-empty">本机暂无月考记录，考完导出待补清单后这里会显示覆盖情况</div>';
    return;
  }
  box.innerHTML='<div class="exam-hitlog-head"><span class="exam-hitlog-title">\\u{1F4CA} 覆盖率看板（本机）</span>'
    +'<span class="exam-hitlog-pills"><span class="pill">累计命中率 '+rateAll+'%</span><span class="pill '+((rateAll>=80)?'':'warn')+'">已沉淀 '+totalAll+' 题</span></span></div>'
    +(monthRows?'<div class="cov-section"><div class="cov-h">各月命中率</div>'+monthRows+'</div>':'')
    +'<div class="cov-grid">'
    +'<div class="cov-col"><div class="cov-h">盲区 Top（待补频次）</div>'+(gapTop?'<ul class="cov-list">'+gapTop+'</ul>':'<div class="exam-gaps-empty">暂无</div>')+'</div>'
    +'<div class="cov-col"><div class="cov-h">命中热度 Top</div>'+(hitTop?'<ul class="cov-list">'+hitTop+'</ul>':'<div class="exam-gaps-empty">暂无</div>')+'</div>'
    +'</div>';
}"""

# 4. CSS：在 .exam-gap-actions 后插入覆盖率看板样式
CSS_OLD = ".exam-gap-actions{display:flex;flex-wrap:wrap;gap:8px;margin-top:8px}"
CSS_NEW = """.exam-gap-actions{display:flex;flex-wrap:wrap;gap:8px;margin-top:8px}
.cov-section{margin-top:8px}
.cov-row{display:flex;align-items:center;gap:10px;font-size:12.5px;padding:2px 0}
.cov-m{color:var(--text2);min-width:64px}
.cov-r{font-weight:700;color:var(--exam-ink)}
.cov-n{color:var(--text2);margin-left:auto}
.cov-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:8px}
.cov-col .cov-h{font-size:12px;font-weight:600;color:var(--text2);margin-bottom:4px}
.cov-list{list-style:none;margin:0;padding:0}
.cov-list li{font-size:12.5px;padding:3px 0;border-bottom:0.5px solid var(--line);display:flex;justify-content:space-between;gap:8px}
.cov-list li .cov-c{color:var(--text2);font-size:11.5px;white-space:nowrap}
@media(max-width:560px){ .cov-grid{grid-template-columns:1fr} }"""

REPL = [
    (CONT_OLD, CONT_NEW, '容器 examCoverage'),
    (CALL_OLD, CALL_NEW, '调用点 renderExamCoverage'),
    (FUNC_ANCHOR, FUNC_INSERT, 'renderExamCoverage 函数'),
    (CSS_OLD, CSS_NEW, 'CSS 覆盖率看板'),
]

def apply(text, fname):
    # CALL_OLD 需出现恰好 3 次（3 个调用点），用 replace 全部替换
    cnt = text.count(CALL_OLD)
    if cnt != 3:
        raise SystemExit(f"[{fname}] renderExamHitLog(); 命中 {cnt} 次（需 3）")
    for old, new, label in REPL:
        if label == '调用点 renderExamCoverage':
            text = text.replace(old, new)
            continue
        c = text.count(old)
        if c != 1:
            raise SystemExit(f"[{fname}] 锚点「{label}」命中 {c} 次（需 1）")
        text = text.replace(old, new)
    return text

for f in FILES:
    t = f.read_text(encoding='utf-8')
    t2 = apply(t, f.name)
    f.write_text(t2, encoding='utf-8')
    print('OK', f.name)
print('done')
