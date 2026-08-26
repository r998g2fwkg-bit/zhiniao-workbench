#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""P1④ 月考命中增强：置信度徽章 + 标题命中高亮 + 近似候选。三端同步。"""
import pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

HELPERS = r'''/** 命中置信度：把匹配分数映射为可读标签与百分比。score 来源：1=精确,0.9=包含,0.75=按序兜底,[0.6,0.9)=Dice 近似。 */
function examConfidence(score){
  const s=score||0;
  if(s>=1)   return {label:'精确匹配', pct:100, level:'exact'};
  if(s>=0.9) return {label:'高度匹配', pct:Math.round(s*100), level:'high'};
  if(s>=0.75)return {label:'按序匹配', pct:Math.round(s*100), level:'mid'};
  if(s>=0.6) return {label:'近似匹配', pct:Math.round(s*100), level:'low'};
  return {label:'未匹配', pct:0, level:'none'};
}
function examConfBadge(score){
  const c=examConfidence(score);
  return '<span class="exam-conf '+c.level+'">'+c.label+' '+c.pct+'%</span>';
}
/** 按序命中的归一化起止位置 [start,endExclusive]，用于片段高亮。 */
function examSeqRange(q, n){
  if(!q||!n||q.length<2||q.length>n.length) return null;
  let pos=-1; const hits=[];
  for(let i=0;i<q.length;i++){
    const idx=n.indexOf(q.charAt(i), pos+1);
    if(idx<0) return null;
    hits.push(idx); pos=idx;
  }
  return [hits[0], hits[hits.length-1]+1];
}
/** 原文字符 → 归一化索引映射，供高亮回写。 */
function examNormMap(title){
  let norm=''; const map=[];
  for(let i=0;i<title.length;i++){
    const cn=examNorm(title[i]);
    if(cn.length===1){ norm+=cn; map.push(i); }
  }
  return {norm:norm, map:map};
}
/** 在命中标题中高亮与查询重叠的片段（黄底 <mark>）。 */
function examHighlightTitleFrag(normQ, title){
  if(!normQ||!title) return esc(title||'');
  const m=examNormMap(title);
  if(!m.norm) return esc(title);
  let lo=-1, hi=-1;
  if(m.norm===normQ){ lo=0; hi=normQ.length; }
  else {
    const idx=m.norm.indexOf(normQ);
    if(idx>=0){ lo=idx; hi=idx+normQ.length; }
    else { const r=examSeqRange(normQ, m.norm); if(r){ lo=r[0]; hi=r[1]; } }
  }
  if(lo<0) return esc(title);
  const hitSet=new Set();
  for(let ci=lo; ci<hi; ci++) hitSet.add(m.map[ci]);
  let out='';
  for(let i=0;i<title.length;i++){
    if(hitSet.has(i)) out+='<mark>'+esc(title[i])+'</mark>';
    else out+=esc(title[i]);
  }
  return out;
}
/** 取次优候选（排除已命中项），供人工复核近似项。 */
function examCandidateList(pool, normQ, type, bestKey, k){
  const lenQ=normQ.length; const res=[];
  for(let i=0;i<pool.length;i++){
    const p=pool[i];
    const label=type==='coach'? p.topic : p.entry.topic;
    const n=examNorm(label); if(!n) continue;
    const key=type==='coach'? p.key : p.entry.id;
    if(key===bestKey) continue;
    const lenN=n.length; let score=0;
    if(n===normQ) score=1;
    else if(n.indexOf(normQ)>=0||normQ.indexOf(n)>=0){
      const shorter=Math.min(lenN,lenQ), longer=Math.max(lenN,lenQ);
      if(shorter>=4&&lenN>=3&&lenQ>=3&&(shorter/longer)>=0.5) score=0.9;
      else { const d=examDice(n,normQ); if(d>=0.60) score=d; }
    } else { const d=examDice(n,normQ); if(d>=0.60) score=d; }
    if(score===0&&lenQ>=2){ const sp=examSequentialMatch(normQ,n); if(sp>0) score=EXAM_SEQ_SCORE; }
    if(score>0) res.push({key:key, topic:label, sheet:type==='coach'? p.sheet : p.entry.sheet,
      id:type==='coach'? (p.items[0]?p.items[0].id:'') : p.entry.id, score:score, type:type});
  }
  res.sort(function(a,b){ return b.score-a.score; });
  return res.slice(0, k||2);
}
function examCandHTML(q){
  if(!q.candidates||!q.candidates.length) return '';
  const items=q.candidates.map(function(c){
    const fn=(c.type==='coach')? ("openDrawer('"+c.id+"', drawerNavIds)") : ("openDemoDrawer('"+c.id+"', drawerNavIds)");
    return '<li class="exam-cand-item" data-id="'+esc(c.id)+'" data-type="'+esc(c.type)+'">'
      +'<span class="exam-cand-title">'+esc(c.topic)+'</span>'
      +'<span class="exam-cand-sheet">'+esc(c.sheet||'')+'</span>'
      +'<span class="exam-cand-score">'+Math.round(c.score*100)+'%</span>'
      +'<button class="btn exam-cand-open" type="button" onclick="'+fn+'">查看</button>'
      +'</li>';
  }).join('');
  return '<div class="exam-cand"><div class="exam-cand-head">近似候选（点击核对是否更贴切）</div><ul class="exam-cand-list">'+items+'</ul></div>';
}

'''

CSS = r'''
.exam-conf{font-size:11px;border-radius:6px;padding:1px 6px;margin-left:6px;font-weight:500}
.exam-conf.exact{color:#1a7f37;background:#e7f6ec}
.exam-conf.high{color:#1a7f37;background:#e7f6ec}
.exam-conf.mid{color:#b06a00;background:#fff3df}
.exam-conf.low{color:#b06a00;background:#fff3df}
.tp-title mark,.exam-cand-title mark{background:#fff1a8;border-radius:3px;padding:0 1px}
.exam-cand{margin:10px 14px 14px;padding:10px 12px;border-top:0.5px solid var(--border)}
.exam-cand-head{font-size:12px;color:var(--text3);margin-bottom:6px}
.exam-cand-list{list-style:none;margin:0;padding:0;display:flex;flex-direction:column;gap:6px}
.exam-cand-item{display:flex;align-items:center;gap:8px;padding:7px 10px;border-radius:10px;background:var(--bg2,#f5f5f7);border:0.5px solid var(--border)}
.exam-cand-title{font-size:13px;color:var(--text1);flex:1;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.exam-cand-sheet{font-size:11px;color:var(--text3);flex:0 0 auto}
.exam-cand-score{font-size:11px;color:var(--text3);flex:0 0 auto}
.exam-cand-open{font-size:11px;padding:3px 9px;border-radius:7px;flex:0 0 auto}
'''

REPLACEMENTS = [
    # 1) 注入辅助函数（锚点：examItemKey 前的注释）
    ('/** 题目的唯一标识：命中项按 type::matchedKey，未命中项按原文。 */\nfunction examItemKey(q){',
     HELPERS + '/** 题目的唯一标识：命中项按 type::matchedKey，未命中项按原文。 */\nfunction examItemKey(q){'),

    # 2) base 增加 normQ / candidates
    ("  const base={order:q.order, seq:q.seq, raw:q.raw, text:q.text,\n"
     "              hintType:q.hintType, hintTag:q.hintTag||null,\n"
     "              hintConflict: !!(q.hintTag && t && q.hintTag!==t),\n"
     "              type:'unknown', matchedId:'', matchedKey:'', matchedEntry:null, score:0};",
     "  const base={order:q.order, seq:q.seq, raw:q.raw, text:q.text,\n"
     "              hintType:q.hintType, hintTag:q.hintTag||null,\n"
     "              hintConflict: !!(q.hintTag && t && q.hintTag!==t),\n"
     "              type:'unknown', matchedId:'', matchedKey:'', matchedEntry:null, score:0,\n"
     "              normQ:examNorm(q.text), candidates:[]};"),

    # 3) coach 分支补充 candidates
    ("    const hit=examMatchInPool(p.coach||[], normQ, 'coach');\n"
     "    if(!hit) return base;\n"
     "    return Object.assign({}, base, {\n"
     "      type:'coach',\n"
     "      matchedId:(hit.item.items[0]? hit.item.items[0].id : ''),\n"
     "      matchedKey:hit.item.key,\n"
     "      matchedEntry:hit.item,\n"
     "      score:hit.score\n"
     "    });",
     "    const hit=examMatchInPool(p.coach||[], normQ, 'coach');\n"
     "    if(!hit) return base;\n"
     "    const cands=examCandidateList(p.coach||[], normQ, 'coach', hit.item.key, 2);\n"
     "    return Object.assign({}, base, {\n"
     "      type:'coach',\n"
     "      matchedId:(hit.item.items[0]? hit.item.items[0].id : ''),\n"
     "      matchedKey:hit.item.key,\n"
     "      matchedEntry:hit.item,\n"
     "      score:hit.score,\n"
     "      candidates:cands\n"
     "    });"),

    # 4) demo 分支补充 candidates
    ("  const hit=examMatchInPool(p.demo||[], normQ, 'demo');\n"
     "  if(!hit) return base;\n"
     "  return Object.assign({}, base, {\n"
     "    type:'demo',\n"
     "    matchedId:hit.item.entry.id,\n"
     "    matchedKey:hit.item.key,\n"
     "    matchedEntry:hit.item,\n"
     "    score:hit.score\n"
     "  });",
     "  const hit=examMatchInPool(p.demo||[], normQ, 'demo');\n"
     "  if(!hit) return base;\n"
     "  const cands=examCandidateList(p.demo||[], normQ, 'demo', hit.item.key, 2);\n"
     "  return Object.assign({}, base, {\n"
     "    type:'demo',\n"
     "    matchedId:hit.item.entry.id,\n"
     "    matchedKey:hit.item.key,\n"
     "    matchedEntry:hit.item,\n"
     "    score:hit.score,\n"
     "    candidates:cands\n"
     "  });"),

    # 5) coach 标题高亮
    ('        <div class="tp-title">${esc(g.topic)}</div>',
     '        <div class="tp-title">${examHighlightTitleFrag(q.normQ, g.topic)}</div>'),

    # 6) demo 标题高亮
    ('        <div class="tp-title">${esc(e.topic)}</div>',
     '        <div class="tp-title">${examHighlightTitleFrag(q.normQ, e.topic)}</div>'),

    # 7) 置信度徽章（coach 与 demo 的 meta 行相同，统一替换）
    ("          ${q.score<1?'<span class=\"exam-fuzzy\">'+ICON_WARN+'模糊匹配</span>':''}\n"
     "        </div>",
     "          ${q.score<1?'<span class=\"exam-fuzzy\">'+ICON_WARN+'模糊匹配</span>':''}\n"
     "          ${q.type!=='unknown'?examConfBadge(q.score):''}\n"
     "        </div>"),

    # 8) coach 卡片追加近似候选
    ("    <div class=\"tp-body\">\n"
     "      <ol class=\"turn-list\">${rounds}</ol>\n"
     "    </div>\n"
     "  </section>`;",
     "    <div class=\"tp-body\">\n"
     "      <ol class=\"turn-list\">${rounds}</ol>\n"
     "    </div>\n"
     "    ${examCandHTML(q)}\n"
     "  </section>`;"),

    # 9) demo 卡片追加近似候选
    ("    <div class=\"tp-body\">\n"
     "      <h4 class=\"d-sub\">店员话术介绍</h4>\n"
     "      <ol class=\"demo-step-list\">${lines}</ol>\n"
     "      <h4 class=\"d-sub\">演示</h4>\n"
     "      ${gallery}\n"
     "    </div>\n"
     "  </section>`;",
     "    <div class=\"tp-body\">\n"
     "      <h4 class=\"d-sub\">店员话术介绍</h4>\n"
     "      <ol class=\"demo-step-list\">${lines}</ol>\n"
     "      <h4 class=\"d-sub\">演示</h4>\n"
     "      ${gallery}\n"
     "    </div>\n"
     "    ${examCandHTML(q)}\n"
     "  </section>`;"),

    # 10) CSS 注入（锚点：.exam-fuzzy 规则后）
    ('.exam-fuzzy{font-size:11px;color:#b06a00;background:#fff3df;border-radius:6px;padding:1px 6px;margin-left:6px}',
     '.exam-fuzzy{font-size:11px;color:#b06a00;background:#fff3df;border-radius:6px;padding:1px 6px;margin-left:6px}' + CSS),
]

for f in FILES:
    text = f.read_text(encoding='utf-8')
    for i,(old,new) in enumerate(REPLACEMENTS):
        assert old in text, f'[{f.name}] 第{i}处旧串未找到'
        text = text.replace(old, new, 1)
    f.write_text(text, encoding='utf-8')
    print(f'OK {f.name}')
print('ALL DONE')
