# -*- coding: utf-8 -*-
import io, sys

FILES = [
    "知鸟答案工作台.html",
    "dist/index.html",
    "dist/index.static.html",
]

# ---- R1: 命中记录常量 ----
R1_OLD = """const K_EXAM_TYPE='wb_zhiniao_exam_type';"""
R1_NEW = """const K_EXAM_TYPE='wb_zhiniao_exam_type';
const K_EXAM_HITS='wb_zhiniao_exam_hits', K_EXAM_GAPS='wb_zhiniao_exam_gaps';"""

# ---- R2: 解析即留痕（插入 examDoParse） ----
R2_OLD = """  examQuestions=list;
  // 手动解析恒回核对清单"""
R2_NEW = """  examQuestions=list;
  // ① 本机命中记录：解析即留痕（命中->第X条，未命中->待补），按 月份+题面 去重
  examQuestions.forEach(function(q){ examRecordQuestion(q); });
  // 手动解析恒回核对清单"""

# ---- R3: HTML 容器 ----
R3_OLD = """      <div class="exam-summary" id="examSummary"></div>"""
R3_NEW = """      <div class="exam-summary" id="examSummary"></div>
      <div class="exam-hitlog" id="examHitLog"></div>"""

# ---- R4: CSS ----
R4_OLD = """.exam-summary .pill{background:var(--exam-soft);color:var(--exam-ink);border-radius:999px;padding:3px 10px;font-weight:600}"""
R4_NEW = """.exam-summary .pill{background:var(--exam-soft);color:var(--exam-ink);border-radius:999px;padding:3px 10px;font-weight:600}
.exam-hitlog{margin:10px 2px 4px;border:0.5px solid var(--line-strong);border-radius:var(--radius);background:var(--surface);backdrop-filter:saturate(180%) blur(20px);-webkit-backdrop-filter:saturate(180%) blur(20px);padding:10px 14px;box-shadow:var(--shadow)}
.exam-hitlog-head{display:flex;flex-wrap:wrap;gap:8px;align-items:center;justify-content:space-between}
.exam-hitlog-title{font-size:13.5px;font-weight:600;color:var(--text1);display:inline-flex;align-items:center;gap:6px}
.exam-hitlog-pills{display:flex;flex-wrap:wrap;gap:6px}
.exam-hitlog .pill{background:var(--exam-soft);color:var(--exam-ink);border-radius:999px;padding:3px 10px;font-weight:600;font-size:12.5px}
.exam-hitlog .pill.warn{background:#FAEEDA;color:#854F0B}
.exam-gaps{margin-top:8px;border-top:0.5px solid var(--line);padding-top:6px}
.exam-gaps>summary{cursor:pointer;font-size:12.5px;color:var(--text2);list-style:none;display:flex;align-items:center;gap:6px}
.exam-gaps>summary::-webkit-details-marker{display:none}
.exam-gaps>summary .chev{margin-left:auto;transition:transform .2s;display:inline-flex}
.exam-gaps[open]>summary .chev{transform:rotate(90deg)}
.exam-gaps-body{padding:8px 2px 2px}
.exam-gaps-body ul{margin:0 0 8px;padding-left:18px;font-size:13px;color:var(--text1);line-height:1.7}
.exam-gaps-empty{font-size:12.5px;color:var(--text3);margin-bottom:8px}"""

# ---- R5: 命中记录 JS 函数块（插在 examClearSession 之前） ----
BIG = """/* ---------- ① 本机命中记录（纯 localStorage，不被清空交接误伤） ---------- */
function loadExamHits(){ try{ return JSON.parse(localStorage.getItem(K_EXAM_HITS)||'[]')||[]; }catch(e){ return []; } }
function saveExamHits(a){ try{ localStorage.setItem(K_EXAM_HITS, JSON.stringify(a)); }catch(e){} }
function loadExamGaps(){ try{ return JSON.parse(localStorage.getItem(K_EXAM_GAPS)||'[]')||[]; }catch(e){ return []; } }
function saveExamGaps(a){ try{ localStorage.setItem(K_EXAM_GAPS, JSON.stringify(a)); }catch(e){} }

/** 解析即留痕：命中记「题->第X条」，未命中记待补。按 月份+题面/命中键 去重，重解析不重复计数。 */
function examRecordQuestion(q){
  if(!q) return;
  const month=examMonthId();
  if(q.type==='unknown'){
    const key=examNorm(q.raw||q.text||'');
    if(!key) return;
    const gaps=loadExamGaps();
    if(gaps.some(function(g){ return g.month===month && g.key===key; })) return;
    gaps.push({key:key, month:month, q:String(q.raw||q.text||''), ts:Date.now()});
    saveExamGaps(gaps);
    return;
  }
  if(!q.matchedKey) return;
  const key=q.type+'::'+q.matchedKey;
  const hits=loadExamHits();
  if(hits.some(function(h){ return h.month===month && h.key===key; })) return;
  const e=q.matchedEntry||{};
  const entry=q.type==='demo' ? (e.entry||{}) : e;
  hits.push({
    key:key, month:month, q:String(q.raw||q.text||''),
    itemId:q.matchedId||'', sheet:entry.sheet||'', topic:entry.topic||'',
    type:q.type, ts:Date.now()
  });
  saveExamHits(hits);
}

/** 本月命中统计：命中率 / 已记录题数 / 待补题数。 */
function examMonthStats(){
  const month=examMonthId();
  const hits=loadExamHits().filter(function(h){ return h.month===month; });
  const gaps=loadExamGaps().filter(function(g){ return g.month===month; });
  const total=hits.length+gaps.length;
  return {
    month:month, hits:hits.length, gaps:gaps.length, total:total,
    rate: total? Math.round(hits.length/total*100) : 0,
    gapList: gaps.slice().reverse()
  };
}

/** 月考模式内「本月命中记录」面板：命中率 / 已记录 / 待补清单（可复制给 Rik 烘焙）。 */
function renderExamHitLog(){
  const box=document.getElementById('examHitLog'); if(!box) return;
  const s=examMonthStats();
  let html='<div class="exam-hitlog-head">'
    +'<span class="exam-hitlog-title">'+ICON_QUESTION+' 本月命中记录 · '+s.month+'</span>'
    +'<span class="exam-hitlog-pills">'
    +'<span class="pill">命中率 '+s.rate+'%</span>'
    +'<span class="pill">已记录 '+s.total+' 题</span>'
    +'<span class="pill warn">待补 '+s.gaps+' 题</span>'
    +'</span></div>';
  html+='<details class="exam-gaps"><summary>待补清单（匹配不到的题，可复制发给 Rik 烘焙进题库）<span class="chev"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg></span></summary>'
    +'<div class="exam-gaps-body">'
    +(s.gapList.length? ('<ul>'+s.gapList.map(function(g){ return '<li>'+esc(g.q)+'</li>'; }).join('')+'</ul>') : '<div class="exam-gaps-empty">本月暂无未匹配题目</div>')
    +'<button class="exam-btn ghost" type="button" id="examCopyGaps"'+(s.gapList.length?'':' disabled')+'>复制待补清单</button>'
    +'</div></details>';
  box.innerHTML=html;
  const cp=document.getElementById('examCopyGaps');
  if(cp) cp.onclick=function(){
    const text=s.gapList.map(function(g){ return g.q; }).join('\\n');
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(text).then(function(){ showToast('待补清单已复制'); }, function(){ showToast('复制失败，请手动选择'); });
    } else { showToast('当前环境不支持复制'); }
  };
}

"""
R5_OLD = """function examClearSession(){"""
R5_NEW = BIG + "\nfunction examClearSession(){"

# ---- R6: renderExam 内调用 ----
R6_OLD = """  renderExamSummary();
  renderExamNav();
  // v2.1：进入月考模式后后台静默预加载 OCR 引擎"""
R6_NEW = """  renderExamSummary();
  renderExamNav();
  renderExamHitLog();
  // v2.1：进入月考模式后后台静默预加载 OCR 引擎"""

# ---- R7: examDoParse 内调用 ----
R7_OLD = """  renderExamSummary(); renderExamNav();
  if(!silent){"""
R7_NEW = """  renderExamSummary(); renderExamNav(); renderExamHitLog();
  if(!silent){"""

# ---- R8: examClearSession 内调用 ----
R8_OLD = """  renderExamList(); renderExamSummary(); renderExamNav();
  showToast('已清空，可交接给下一位');"""
R8_NEW = """  renderExamList(); renderExamSummary(); renderExamNav(); renderExamHitLog();
  showToast('已清空，可交接给下一位');"""

REPLACEMENTS = [
    ("R1", R1_OLD, R1_NEW),
    ("R2", R2_OLD, R2_NEW),
    ("R3", R3_OLD, R3_NEW),
    ("R4", R4_OLD, R4_NEW),
    ("R5", R5_OLD, R5_NEW),
    ("R6", R6_OLD, R6_NEW),
    ("R7", R7_OLD, R7_NEW),
    ("R8", R8_OLD, R8_NEW),
]

for fp in FILES:
    text = open(fp, encoding="utf-8").read()
    for name, old, new in REPLACEMENTS:
        cnt = text.count(old)
        if cnt != 1:
            raise SystemExit("FAIL %s in %s: anchor count=%d (expected 1)" % (name, fp, cnt))
        text = text.replace(old, new, 1)
    open(fp, "w", encoding="utf-8").write(text)
    print("OK  ", fp)

# 最终一致性交叉校验
src = open(FILES[0], encoding="utf-8").read()
for fp in FILES[1:]:
    t = open(fp, encoding="utf-8").read()
    if t != src:
        # 仅允许 dist 与源在极少数已知内嵌差异？这里要求完全一致
        raise SystemExit("FAIL consistency: %s differs from source" % fp)
print("CONSISTENT: 3 files identical")
