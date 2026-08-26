#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""三端同步：P2⑦ 语音无中文语音兜底 + 检索容错。"""
import pathlib, re

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

# ---------- 1. 语音状态变量：追加兜底标志 ----------
STATE_OLD = "let keepAliveTimer=null, speechSupported=false, currentDrawerId=null;"
STATE_NEW = ("let keepAliveTimer=null, speechSupported=false, currentDrawerId=null,\n"
            "    speechNoZh=false, speechNoZhWarned=false, speechErrWarned=false;")

# ---------- 2. 工具函数：speechHasZh / 检索容错 ----------
HELPERS_OLD = "function getVoicesSafe(){ try{ return speechSynthesis.getVoices()||[]; }catch(e){ return []; } }"
HELPERS_NEW = """function getVoicesSafe(){ try{ return speechSynthesis.getVoices()||[]; }catch(e){ return []; } }
function speechHasZh(){ return getVoicesSafe().some(v=>/^zh/i.test(v.lang)); }
/* 检索容错：去空格/标点、小写；支持多词 AND 与子序列兜底 */
function normalizeSearch(s){ return String(s||'').toLowerCase().replace(/[\\s，。、/！？!?…·\\-_()（）：:；;]+/g,''); }
function isSubsequence(needle, hay){
  if(!needle) return true; let i=0;
  for(let c of hay){ if(c===needle[i]){ i++; if(i>=needle.length) return true; } }
  return i>=needle.length;
}
function searchHit(haystack, query){
  const nq=normalizeSearch(query); if(!nq) return true;
  const nh=normalizeSearch(haystack);
  if(nh.includes(nq)) return true;
  // 多词：按原分隔拆词（AND）
  const terms=String(query).toLowerCase().split(/[\\s，、/]+/).map(w=>normalizeSearch(w)).filter(Boolean);
  if(terms.length>1 && terms.every(t=>nh.includes(t))) return true;
  // 子序列兜底（去空格后仍无法连续命中，容忍“的/了”等夹杂）
  if(nq.length>=2 && isSubsequence(nq, nh)) return true;
  return false;
}"""

# ---------- 3. initSpeech：填充后评估中文语音并挂警告；onvoiceschanged 也评估 ----------
INIT_OLD = "  voices=getVoicesSafe();\n  populateVoiceSelect();"
INIT_NEW = ("  voices=getVoicesSafe();\n  populateVoiceSelect();\n"
            "  speechWarnNoZh();")
ONVOICES_OLD = "speechSynthesis.onvoiceschanged=()=>{ voices=getVoicesSafe(); populateVoiceSelect(); };"
ONVOICES_NEW = "speechSynthesis.onvoiceschanged=()=>{ voices=getVoicesSafe(); populateVoiceSelect(); speechWarnNoZh(); };"

# ---------- 4. speakItems：无中文语音时提示一次 ----------
SPEAK_OLD = "  if(!hasSpeech()){ showToast('当前浏览器不支持本地语音朗读'); return; }"
SPEAK_NEW = ("  if(!hasSpeech()){ showToast('当前浏览器不支持本地语音朗读'); return; }\n"
             "  if(speechNoZh && !speechNoZhWarned){ speechNoZhWarned=true; showToast('设备未安装中文语音，朗读可能无声或失真。请在系统设置安装中文语音（macOS：系统设置→辅助功能→语音→下载中文语音；Windows：设置→时间和语言→语音→添加中文(中国)）',4200); }")

# ---------- 5. speechWarnNoZh 函数 + onerror 增强（插在 initSpeech 之前） ----------
WARN_FN_OLD = "function initSpeech(){"
WARN_FN_NEW = """function speechWarnNoZh(){
  speechNoZh = hasSpeech() ? !speechHasZh() : false;
  const st=document.getElementById('speechStatus'), lb=document.getElementById('speechLabel'), bar=document.getElementById('speechBar');
  if(!st||!lb) return;
  if(speechNoZh){ st.textContent='⚠️ 未检测到中文语音'; st.classList.add('no-zh'); lb.textContent='朗读可能无声或失真，请在系统设置安装中文语音'; if(bar) bar.classList.add('no-zh'); }
  else { st.classList.remove('no-zh'); if(bar) bar.classList.remove('no-zh'); }
}
function initSpeech(){"""

ONERROR_OLD = "  u.onerror=()=>{ if(speechUtterance!==u || !speechPlaying || speechPaused) return; speechResumeOffset=0; speechIndex++; playNextSpeech(); };"
ONERROR_NEW = ("  u.onerror=(ev)=>{\n"
               "    if(speechUtterance!==u || !speechPlaying || speechPaused) return;\n"
               "    const err = (ev&&ev.error)||'';\n"
               "    if(err && err!=='canceled' && err!=='interrupted' && !speechErrWarned){\n"
               "      speechErrWarned=true;\n"
               "      showToast('语音朗读出错（'+err+'），请检查设备中文语音是否可用',3200);\n"
               "    }\n"
               "    speechResumeOffset=0; speechIndex++; playNextSpeech();\n"
               "  };")

# ---------- 6. 三处检索 includes -> searchHit ----------
S1_OLD = "if(q) topics=topics.filter(x=>(x.topic+x.question+x.answer+x.keywords+x.sheet+x.category).toLowerCase().includes(q));"
S1_NEW = "if(q) topics=topics.filter(x=>searchHit((x.topic+x.question+x.answer+x.keywords+x.sheet+x.category), q));"
S2_OLD = "if(q) topics=topics.filter(x=>(x.topic+x.question+x.answer+x.keywords).toLowerCase().includes(q));"
S2_NEW = "if(q) topics=topics.filter(x=>searchHit((x.topic+x.question+x.answer+x.keywords), q));"
S3_OLD = "if(q) list=list.filter(x=>(x.topic+' '+x.intro+' '+x.sheet+' '+(x.category||'')).toLowerCase().includes(q));"
S3_NEW = "if(q) list=list.filter(x=>searchHit((x.topic+' '+x.intro+' '+x.sheet+' '+(x.category||'')), q));"

# ---------- 7. CSS：无中文语音状态色 ----------
CSS_OLD = ".speech-bar .speech-status{font-size:13px;font-weight:600;color:var(--text);line-height:1.2;white-space:nowrap}"
CSS_NEW = (".speech-bar .speech-status{font-size:13px;font-weight:600;color:var(--text);line-height:1.2;white-space:nowrap}\n"
          ".speech-bar .speech-status.no-zh{color:#c2410c}\n"
          ".speech-bar.no-zh #speechStatus{color:#c2410c}")

REPLACEMENTS = [
    (STATE_OLD, STATE_NEW, '语音状态变量'),
    (HELPERS_OLD, HELPERS_NEW, '工具函数 speechHasZh/检索容错'),
    (INIT_OLD, INIT_NEW, 'initSpeech 评估中文语音'),
    (ONVOICES_OLD, ONVOICES_NEW, 'onvoiceschanged 评估'),
    (SPEAK_OLD, SPEAK_NEW, 'speakItems 兜底提示'),
    (WARN_FN_OLD, WARN_FN_NEW, 'speechWarnNoZh 函数'),
    (ONERROR_OLD, ONERROR_NEW, 'onerror 增强'),
    (S1_OLD, S1_NEW, '检索①'),
    (S2_OLD, S2_NEW, '检索②'),
    (S3_OLD, S3_NEW, '检索③'),
    (CSS_OLD, CSS_NEW, 'CSS 无语音状态色'),
]

def apply(text, fname):
    for old, new, label in REPLACEMENTS:
        cnt = text.count(old)
        if cnt != 1:
            raise SystemExit(f"[{fname}] 锚点「{label}」命中 {cnt} 次（需恰好 1 次）")
        text = text.replace(old, new)
    return text

for f in FILES:
    t = f.read_text(encoding='utf-8')
    t2 = apply(t, f.name)
    f.write_text(t2, encoding='utf-8')
    print(f"OK {f.name}")
print("done")
