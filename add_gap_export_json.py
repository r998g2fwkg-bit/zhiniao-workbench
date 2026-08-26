import pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

OLD_LABEL = "+'>导出为文件(.txt)</button>'"
NEW_LABEL = "+'>导出汇总(.json)</button>'"

OLD_BLOCK = """  const exp=document.getElementById('examExportGaps');
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
  };"""

NEW_BLOCK = """  const exp=document.getElementById('examExportGaps');
  if(exp) exp.onclick=function(){
    try{
      const month=s.month;
      const em=getSessionEmail();
      const store=userName(em)||em||'未知门店';
      const payload={
        tool:'zhiniao-exam-gaps', version:1,
        store:store, email:(em||''), month:month,
        exportedAt:new Date().toISOString(),
        gaps:s.gapList.map(function(g){ return {q:g.q, key:g.key||examNorm(g.q)}; }),
        hits:loadExamHits().filter(function(h){ return h.month===month; }).map(function(h){ return {q:h.q, sheet:h.sheet||'', topic:h.topic||'', itemId:h.itemId||'', type:h.type||''}; })
      };
      const blob=new Blob([JSON.stringify(payload,null,2)], {type:'application/json;charset=utf-8'});
      const url=URL.createObjectURL(blob);
      const a=document.createElement('a');
      a.href=url; a.download='待补清单_'+store+'_'+month+'.json';
      document.body.appendChild(a); a.click(); document.body.removeChild(a);
      URL.revokeObjectURL(url);
      showToast('汇总文件已导出');
    }catch(e){ showToast('导出失败'); }
  };"""

for f in FILES:
    t = f.read_text(encoding='utf-8')
    assert OLD_LABEL in t, f"{f.name}: label not found"
    assert OLD_BLOCK in t, f"{f.name}: export block not found"
    assert '导出汇总(.json)' not in t, f"{f.name}: already converted"
    t = t.replace(OLD_LABEL, NEW_LABEL, 1)
    t = t.replace(OLD_BLOCK, NEW_BLOCK, 1)
    f.write_text(t, encoding='utf-8')
    print("updated:", f.name)
print("DONE")
