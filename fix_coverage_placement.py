#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""修复：将误嵌套在 onclick 内的 renderExamCoverage 移到顶层。"""
import pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

NESTED_OPEN = "  if(exp) exp.onclick=function(){\n/** 覆盖率看板"
FUNC_HEADER = "function renderExamCoverage(){"
CLEAR_ANCHOR = "function examClearSession(){"

for f in FILES:
    t = f.read_text(encoding='utf-8')
    # 1. 找到误嵌套的函数定义块（从 function renderExamCoverage(){ 到它紧邻的 } + '    try{' 之前）
    hs = t.index(FUNC_HEADER)
    # 该函数结束于 '}\n    try{' 中的 '}'
    end_idx = t.index('}\n    try{', hs) + 1   # 含 '}'
    func_block = t[hs:end_idx+1]
    # 2. 移除嵌套位置：从 NESTED_OPEN 到 end_idx（含 '}'）整段删除，恢复 onclick 直接接 try{
    ns = t.index(NESTED_OPEN)
    t = t[:ns] + "  if(exp) exp.onclick=function(){" + t[end_idx+1:]
    # 3. 将函数块插入顶层（examClearSession 之前）
    ci = t.index(CLEAR_ANCHOR)
    t = t[:ci] + func_block + "\n\n" + t[ci:]
    f.write_text(t, encoding='utf-8')
    print('OK', f.name)
print('done')
