# -*- coding: utf-8 -*-
import sys, io

FILES = ["知鸟答案工作台.html", "dist/index.html", "dist/index.static.html"]

OLD_BTN = '''    +'<button class="exam-btn ghost" type="button" id="examCopyGaps"'+(s.gapList.length?'':' disabled')+'>复制待补清单</button>'
    +'</div></details>';'''

NEW_BTN = '''    +'<div class="exam-gap-actions">'
    +'<button class="exam-btn ghost" type="button" id="examCopyGaps"'+(s.gapList.length?'':' disabled')+'>复制待补清单</button>'
    +'<button class="exam-btn ghost" type="button" id="examExportGaps"'+(s.gapList.length?'':' disabled')+'>导出为文件(.txt)</button>'
    +'</div>'
    +'</div></details>';'''

OLD_BIND = '''    } else { showToast('当前环境不支持复制'); }
  };'''

NEW_BIND = '''    } else { showToast('当前环境不支持复制'); }
  };
  const exp=document.getElementById('examExportGaps');
  if(exp) exp.onclick=function(){
    const text=s.gapList.map(function(g){ return g.q; }).join('\\n');
    try{
      const blob=new Blob([text], {type:'text/plain;charset=utf-8'});
      const url=URL.createObjectURL(blob);
      const a=document.createElement('a');
      a.href=url; a.download='待补清单_'+s.month+'.txt';
      document.body.appendChild(a); a.click(); document.body.removeChild(a);
      URL.revokeObjectURL(url);
      showToast('待补清单已导出');
    }catch(e){ showToast('导出失败'); }
  };'''

OLD_CSS = '''.exam-gaps-body{padding:8px 2px 2px}'''
NEW_CSS = '''.exam-gaps-body{padding:8px 2px 2px}
.exam-gap-actions{display:flex;flex-wrap:wrap;gap:8px;margin-top:8px}'''

for fp in FILES:
    with io.open(fp, encoding='utf-8') as f:
        s = f.read()
    # 每处必须恰好出现 1 次
    for name, old, new in [("按钮区", OLD_BTN, NEW_BTN), ("JS绑定", OLD_BIND, NEW_BIND), ("CSS", OLD_CSS, NEW_CSS)]:
        cnt = s.count(old)
        assert cnt == 1, "%s : %s 出现 %d 次 (期望 1)" % (fp, name, cnt)
        s = s.replace(old, new, 1)
    with io.open(fp, 'w', encoding='utf-8') as f:
        f.write(s)
    print("OK ", fp)

# 三端一致性断言
with io.open(FILES[0], encoding='utf-8') as f: src = f.read()
with io.open(FILES[1], encoding='utf-8') as f: d1 = f.read()
with io.open(FILES[2], encoding='utf-8') as f: d2 = f.read()
assert src == d1 == d2, "三端不一致!"
print("三端一致 OK")
# 关键特征断言
assert "id=\"examExportGaps\"" in src
assert "待补清单_'+s.month+'.txt'" in src or "待补清单_'+s.month+'.txt'" in src
assert ".exam-gap-actions{" in src
print("特征断言 OK")
