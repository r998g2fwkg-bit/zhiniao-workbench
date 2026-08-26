#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""从三端 HTML 文件中彻底删除 AEP 周任务相关代码。
基于当前 source 行号，从后往前删，避免行号漂移。
"""
import pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

# 基于 source 当前行号（1-based）的删除区间，按行号降序处理
DELETE_RANGES = [
    (3396, 3500),   # AEP 函数块
    (1707, 1750),   # AEP_WEEKLY 常量
    (1411, 1437),   # AEP HTML section
    (717, 750),     # AEP CSS
]

def delete_lines(lines, start, end):
    # 转为 0-based
    return lines[:start-1] + lines[end:]

def remove_aep_from_text(text: str, fp: str) -> str:
    lines = text.splitlines(keepends=True)
    
    # 1. 从后往前删除整行区间
    for start, end in DELETE_RANGES:
        lines = delete_lines(lines, start, end)
    
    text = ''.join(lines)
    
    # 2. 删除单行 Tab 按钮（L1347）——区间删除后行号变了，用文本替换
    text = text.replace(
        '      <button class="sec-tab" data-sec="aep"><svg class="tab-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="4" width="14" height="17" rx="2"/><path d="M8.5 9l1.2 1.2L12.5 7.5"/><path d="M8.5 14l1.2 1.2L12.5 12.5"/><path d="M14.5 9h2.5"/><path d="M14.5 14h2.5"/></svg>AEP周任务</button>\n',
        ''
    )
    
    # 3. 更新注释
    text = text.replace(
        '  /* 话术库未命中 → 尝试演示库（AEP 版块等跨版块打开演示详情场景） */',
        '  /* 话术库未命中 → 尝试演示库（跨版块打开演示详情场景） */'
    )
    
    # 4. setSection 函数修改
    text = text.replace(
        "  document.body.classList.toggle('demo-section', sec==='demo');\n  document.body.classList.toggle('exam-section', sec==='exam');\n  document.body.classList.toggle('salary-section', sec==='salary');\n  document.body.classList.toggle('aep-section', sec==='aep');",
        "  document.body.classList.toggle('demo-section', sec==='demo');\n  document.body.classList.toggle('exam-section', sec==='exam');\n  document.body.classList.toggle('salary-section', sec==='salary');"
    )
    text = text.replace(
        "if(title) title.textContent = sec==='demo'?'Ai Demo':(sec==='exam'?'月考模式':(sec==='salary'?'激励计算器':(sec==='aep'?'AEP周任务':'Ai Coach')));",
        "if(title) title.textContent = sec==='demo'?'Ai Demo':(sec==='exam'?'月考模式':(sec==='salary'?'激励计算器':'Ai Coach'));"
    )
    text = text.replace(
        "const si=document.getElementById('searchInput'); if(si) si.placeholder = sec==='demo'?'搜索 Ai Demo 主题、介绍或关键词…':(sec==='exam'?'月考模式：粘贴题目清单以调出内容':(sec==='aep'?'本周 AEP 学习任务…':'搜索主题、问题、答案或关键词…'));",
        "const si=document.getElementById('searchInput'); if(si) si.placeholder = sec==='demo'?'搜索 Ai Demo 主题、介绍或关键词…':(sec==='exam'?'月考模式：粘贴题目清单以调出内容':'搜索主题、问题、答案或关键词…');"
    )
    text = text.replace(
        "const cl=document.getElementById('cardList'); if(cl) cl.style.display = (sec==='exam'||sec==='salary'||sec==='aep') ? 'none' : '';",
        "const cl=document.getElementById('cardList'); if(cl) cl.style.display = (sec==='exam'||sec==='salary') ? 'none' : '';"
    )
    
    # 5. 删除 setSection 中 aep 分支整块（从 else if(sec==='aep'){ 开始到下一个 else/else if 之前）
    import re
    text = re.sub(
        r"  else if\(sec==='aep'\)\{\n"
        r"    if\(gt\) gt\.style\.display='none';\n"
        r"    try\{ stopSpeech\(false\); \}catch\(e\)\{\}\n"
        r"    const rc=document\.getElementById\('resultCount'\); if\(rc\)\{ rc\.textContent=''; rc\.style\.display='none'; \}\n"
        r"    /\* AEP 模式：隐藏工具栏 / 搜索栏 / 筛选条 / 统计区 / 图表区 / 关键词区，只保留 PDF \+ 匹配清单 \*/\n"
        r"    const wt=document\.querySelector\('\.work-toolbar'\); if\(wt\) wt\.style\.display='none';\n"
        r"    const sw=document\.querySelector\('\.search-wrap'\); if\(sw\) sw\.style\.display='none';\n"
        r"    const ov=document\.querySelector\('\.overview'\); if\(ov\) ov\.style\.display='none';\n"
        r"    const kw=document\.querySelector\('\.kw-section'\); if\(kw\) kw\.style\.display='none';\n"
        r"  \}\n",
        '', text
    )
    text = re.sub(
        r"  const aw=document\.getElementById\('aepWrap'\); if\(aw\) aw\.style\.display = sec==='aep' \? '' : 'none';\n",
        '', text
    )
    text = re.sub(
        r"  /\* 离开 AEP 版块释放 PDF iframe \*/\n  if\(sec!=='aep'\) aepReleaseFrame\(\);\n",
        '', text
    )
    text = re.sub(
        r"  if\(sec==='aep'\) renderAEP\(\);\n",
        '', text
    )
    
    assert 'aep' not in text.lower(), f'{fp}: still contains aep/AEP'
    assert 'AEP' not in text, f'{fp}: still contains AEP'
    return text

for fp in FILES:
    text = fp.read_text(encoding='utf-8')
    text = remove_aep_from_text(text, str(fp))
    fp.write_text(text, encoding='utf-8')
    print('CLEANED', fp)

print('ALL AEP REFERENCES REMOVED')
