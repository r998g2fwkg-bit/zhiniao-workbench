#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""P0② 最近更新变更日志：CHANGELOG 常量 + 渲染 + 容器 + CSS，三端同步。"""
import pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

CHANGELOG_CONST = r'''/** 最近更新日志（P0②）：AI 每次烘焙改动时由人工在数组头部追加一条。
 * 仅做展示，不参与任何匹配/统计逻辑；存量 194 条无 createdAt，此日志弥补「改了什么看不见」。 */
const CHANGELOG=[
  {date:'2026-08-17', type:'增强', desc:'月考命中：置信度徽章 + 标题命中高亮 + 近似候选'},
  {date:'2026-08-17', type:'优化', desc:'待补清单支持跨店汇总导出(.json)与合并烘焙'},
  {date:'2026-08-17', type:'改名', desc:'测试账户改名为「Onezero长沙河西王府井店」'},
  {date:'2026-08-16', type:'修正', desc:'AEP 周任务起止改为周日至周六'},
  {date:'2026-08-16', type:'新增', desc:'头像点击强制刷新；新增测试账户头像'}
];

/** 概览区「最近更新」面板：按日期倒序展示前 6 条。 */
function renderChangelog(){
  const box=document.getElementById('changelog'); if(!box) return;
  if(!CHANGELOG || !CHANGELOG.length){ box.style.display='none'; return; }
  const items=CHANGELOG.slice().sort(function(a,b){ return (b.date||'').localeCompare(a.date||''); }).slice(0,6).map(function(c){
    const t=c.type||'其他';
    return '<li class="cl-item"><span class="cl-date">'+esc(c.date||'')+'</span>'
      +'<span class="cl-type cl-'+esc(t)+'">'+esc(t)+'</span>'
      +'<span class="cl-desc">'+esc(c.desc||'')+'</span></li>';
  }).join('');
  box.innerHTML='<div class="cl-head">📝 最近更新</div><ul class="cl-list">'+items+'</ul>';
  box.style.display='';
}

'''

CSS = r'''
.ov-changelog{margin:14px 0 4px;padding:14px 16px;border-radius:var(--radius);background:var(--surface-solid);border:0.5px solid var(--line)}
.cl-head{font-size:13.5px;font-weight:600;color:var(--text1);margin-bottom:10px}
.cl-list{list-style:none;margin:0;padding:0;display:flex;flex-direction:column;gap:7px}
.cl-item{display:flex;align-items:center;gap:10px;font-size:12.5px;line-height:1.4}
.cl-date{color:var(--text3);flex:0 0 auto;font-variant-numeric:tabular-nums}
.cl-type{flex:0 0 auto;font-size:11px;border-radius:6px;padding:1px 7px;color:#1a7f37;background:#e7f6ec}
.cl-type.修正{color:#b06a00;background:#fff3df}
.cl-type.改名{color:#0071e3;background:#e8f1fe}
.cl-type.新增{color:#7a4ddb;background:#f1e9fe}
.cl-desc{color:var(--text2);flex:1;min-width:0}
'''

REPLACEMENTS = [
    # 1) 常量 + 渲染函数（锚点：renderStats 前）
    ('function renderStats(){',
     CHANGELOG_CONST + 'function renderStats(){'),

    # 2) 在 renderStats 开头统一调用（避开 demo 分支内转义引号）
    ('function renderStats(){\n  if(section===\'demo\'){',
     'function renderStats(){\n  renderChangelog();\n  if(section===\'demo\'){'),

    # 3) 容器（概览 section 之后）
    ('    </section>\n    <section class="kw-section">',
     '    </section>\n    <div id="changelog" class="ov-changelog"></div>\n    <section class="kw-section">'),

    # 4) CSS 注入
    ('.ov-stat{display:flex;flex-direction:column;gap:3px;padding:10px 12px;border-radius:var(--radius-sm);background:var(--surface-solid);border:0.5px solid var(--line)}',
     '.ov-stat{display:flex;flex-direction:column;gap:3px;padding:10px 12px;border-radius:var(--radius-sm);background:var(--surface-solid);border:0.5px solid var(--line)}' + CSS),
]

for f in FILES:
    text = f.read_text(encoding='utf-8')
    for i,(old,new) in enumerate(REPLACEMENTS):
        assert old in text, f'[{f.name}] 第{i}处旧串未找到'
        text = text.replace(old, new, 1)
    f.write_text(text, encoding='utf-8')
    print(f'OK {f.name}')
print('ALL DONE')
