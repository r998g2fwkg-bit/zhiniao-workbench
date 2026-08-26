import pathlib, re

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

# ---------- 1. CSS：备份相关样式（紧跟 .import-input{display:none} 之后） ----------
CSS_ADD = """
.backup-auto{display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-2);padding:2px 4px;cursor:pointer;user-select:none}
.backup-auto input{width:14px;height:14px;accent-color:var(--accent);cursor:pointer}
#btnRestoreSnap .snap-info{font-size:11px;opacity:.6;margin-left:4px}"""

# ---------- 2. JS：替换 exportJSON/importJSON 区块（2815-2843） ----------
OLD_JS = '''function exportJSON(){
  // 授权邮箱列表跟着数据一起导出，换设备时权限不丢失；种子邮箱由代码固定，不必重复备份
  const extraAllowed=getAllowed().filter(e=>!SEED_EMAILS.includes(e.toLowerCase()));
  const blob=new Blob([JSON.stringify({data,favorites:[...favorites],allowed:extraAllowed},null,2)],{type:'application/json'});
  const a=document.createElement('a');
  a.href=URL.createObjectURL(blob);
  a.download=`知鸟答案备份_${new Date().toISOString().slice(0,10)}.json`;
  a.click(); URL.revokeObjectURL(a.href);
  showToast('备份已导出');
}
function importJSON(file){
  const r=new FileReader();
  r.onload=e=>{
    try{
      const p=JSON.parse(e.target.result);
      const arr=Array.isArray(p)?p:p.data;
      if(!Array.isArray(arr)||!arr.length) throw new Error('格式不正确');
      data=arr;
      if(!Array.isArray(p) && Array.isArray(p.favorites)) favorites=new Set(p.favorites);
      // 若备份包含授权邮箱列表，一并恢复，避免换设备后新授权邮箱失效
      if(!Array.isArray(p) && Array.isArray(p.allowed)){
        try{ localStorage.setItem(K_ALLOWED,JSON.stringify(p.allowed)); }catch(e){}
      }
      saveData(); saveFav(); render();
      showToast(`导入成功，共 ${arr.length} 条`);
    }catch(err){ showToast('导入失败：'+err.message); }
  };
  r.readAsText(file);
}'''

NEW_JS = '''/* ============ 全量备份 / 一键恢复 / 浏览器内滚动快照 ============ */
const K_BACKUPS='wb_zhiniao_backups';            // 浏览器内滚动快照
const K_LAST_AUTO_BACKUP='wb_zhiniao_last_auto_backup';
const K_AUTO_BACKUP='wb_zhiniao_auto_backup';
const BACKUP_PREFIX='wb_zhiniao_';
const BACKUP_SCHEMA=1;
function collectAllState(){
  const keys={};
  for(let i=0;i<localStorage.length;i++){
    const k=localStorage.key(i);
    if(k && k.indexOf(BACKUP_PREFIX)===0){ try{ keys[k]=localStorage.getItem(k); }catch(e){} }
  }
  return keys;
}
function backupAll(download){
  const payload={tool:'zhiniao-backup',version:BACKUP_SCHEMA,createdAt:new Date().toISOString(),keys:collectAllState()};
  const json=JSON.stringify(payload,null,2);
  if(download){
    const blob=new Blob([json],{type:'application/json'});
    const a=document.createElement('a');
    a.href=URL.createObjectURL(blob);
    a.download=`知鸟全量备份_${new Date().toISOString().slice(0,10)}.json`;
    a.click(); URL.revokeObjectURL(a.href);
    try{ localStorage.setItem(K_LAST_AUTO_BACKUP,String(Date.now())); }catch(e){}
    showToast('全量备份已下载');
  }
  return payload;
}
function importJSON(file){
  const r=new FileReader();
  r.onload=e=>{
    try{
      const p=JSON.parse(e.target.result);
      const restoreKeys=(pk)=>{ if(!pk) return; for(const k in pk){ try{ localStorage.setItem(k,pk[k]); }catch(_){} } };
      if(p && p.tool==='zhiniao-backup' && p.keys){
        restoreKeys(p.keys);
      } else {
        const arr=Array.isArray(p)?p:p.data;
        if(!Array.isArray(arr)||!arr.length) throw new Error('格式不正确');
        data=arr;
        if(!Array.isArray(p) && Array.isArray(p.favorites)) favorites=new Set(p.favorites);
        const m={};
        m[BACKUP_PREFIX+'data']=JSON.stringify(data);
        m[BACKUP_PREFIX+'favorites']=JSON.stringify([...favorites]);
        if(!Array.isArray(p) && Array.isArray(p.allowed)) m[BACKUP_PREFIX+'allowed']=JSON.stringify(p.allowed);
        restoreKeys(m);
      }
      showToast('导入成功，正在恢复…');
      setTimeout(()=>location.reload(),400);
    }catch(err){ showToast('导入失败：'+err.message); }
  };
  r.readAsText(file);
}
function rollingSnapshot(){
  let arr=[]; try{ arr=JSON.parse(localStorage.getItem(K_BACKUPS)||'[]')||[]; }catch(e){ arr=[]; }
  const last=arr.length?arr[arr.length-1].ts:0;
  if(Date.now()-last < 7*24*3600*1000) return;     // 7 天内已有快照则不重复
  arr.push({ts:Date.now(),keys:collectAllState()});
  if(arr.length>5) arr=arr.slice(arr.length-5);
  try{ localStorage.setItem(K_BACKUPS,JSON.stringify(arr)); }catch(e){}
}
function restoreSnapshot(idx){
  let arr=[]; try{ arr=JSON.parse(localStorage.getItem(K_BACKUPS)||'[]')||[]; }catch(e){ arr=[]; }
  if(!arr.length){ showToast('暂无浏览器内快照'); return; }
  const snap=(typeof idx==='number')?arr[idx]:arr[arr.length-1];
  if(!confirm('将用「'+new Date(snap.ts).toLocaleString()+'」的浏览器内快照覆盖当前数据，确定继续？')) return;
  for(const k in snap.keys){ try{ localStorage.setItem(k,snap.keys[k]); }catch(_){} }
  showToast('已从快照恢复，正在刷新…');
  setTimeout(()=>location.reload(),400);
}
function autoBackupMaybe(){
  if(localStorage.getItem(K_AUTO_BACKUP)==='false') return;
  const last=parseInt(localStorage.getItem(K_LAST_AUTO_BACKUP)||'0',10);
  if(Date.now()-last < 7*24*3600*1000) return;
  try{ backupAll(true); }catch(e){}
}
function renderBackupUI(){
  const btn=document.getElementById('btnRestoreSnap');
  if(btn){
    let arr=[]; try{ arr=JSON.parse(localStorage.getItem(K_BACKUPS)||'[]')||[]; }catch(e){}
    const info=btn.querySelector('.snap-info');
    if(info) info.textContent = arr.length ? '（最近 '+new Date(arr[arr.length-1].ts).toLocaleDateString()+'）' : '（暂无）';
  }
  const chk=document.getElementById('autoBackupChk');
  if(chk) chk.checked = localStorage.getItem(K_AUTO_BACKUP)!=='false';
}
function initAutoBackup(){ rollingSnapshot(); renderBackupUI(); autoBackupMaybe(); }'''

# ---------- 3. HTML：btnExport 改名、新增恢复快照 + 自动备份开关 ----------
OLD_BTN_EXPORT = '''      <button class="btn admin-only" id="btnExport"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 4v11"/><path d="M7 10l5-5 5 5"/><path d="M20 15v3a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3"/></svg>导出备份</button>'''
NEW_BTN_EXPORT = '''      <button class="btn admin-only" id="btnExport"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 4v11"/><path d="M7 10l5-5 5 5"/><path d="M20 15v3a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3"/></svg>全量备份</button>'''

OLD_BTN_IMPORT = '''      <button class="btn admin-only" id="btnImport"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20V9"/><path d="M17 14l-5 5-5-5"/><path d="M20 15v3a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3"/></svg>导入恢复</button>'''
NEW_BTN_IMPORT = '''      <button class="btn admin-only" id="btnImport"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20V9"/><path d="M17 14l-5 5-5-5"/><path d="M20 15v3a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3"/></svg>导入恢复</button>
      <button class="btn admin-only" id="btnRestoreSnap"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 3-6.7"/><path d="M3 4v4h4"/><path d="M12 8v4l3 2"/></svg>恢复最近快照<span class="snap-info">（暂无）</span></button>
      <label class="backup-auto admin-only"><input type="checkbox" id="autoBackupChk"> 每周自动下载备份</label>'''

# ---------- 4. 命令面板引用 exportJSON -> backupAll ----------
OLD_CMD = "    {label:'导出备份 (JSON)',sub:'数据',icon:ICON_EXPORT,action:exportJSON},"
NEW_CMD = "    {label:'全量备份 (JSON)',sub:'数据',icon:ICON_EXPORT,action:()=>backupAll(true)},"

# ---------- 5. 事件绑定 ----------
OLD_BIND = "document.getElementById('btnExport').onclick=exportJSON;"
NEW_BIND = """document.getElementById('btnExport').onclick=()=>backupAll(true);
document.getElementById('btnRestoreSnap').onclick=()=>restoreSnapshot();
document.getElementById('autoBackupChk').onchange=e=>{ try{ localStorage.setItem('wb_zhiniao_auto_backup', e.target.checked?'true':'false'); }catch(_){} showToast(e.target.checked?'已开启自动备份':'已关闭自动备份'); };"""

# ---------- 6. 启动 hook ----------
OLD_INIT = "render();\ninitSpeech();"
NEW_INIT = "render();\ninitAutoBackup();\ninitSpeech();"

# ---------- 7. 备份提醒文案更新 ----------
OLD_REMIND = "数据已积累 30 条以上，建议导出 JSON 备份，防止浏览器清理后丢失。"
NEW_REMIND = "数据已积累 30 条以上，可点左侧「恢复最近快照」防误删，或「全量备份」下载文件，防止浏览器清理后丢失。"

for f in FILES:
    t = f.read_text(encoding='utf-8')
    assert OLD_JS in t, f"{f.name}: JS block not found"
    assert OLD_BTN_EXPORT in t, f"{f.name}: btnExport not found"
    assert OLD_BTN_IMPORT in t, f"{f.name}: btnImport not found"
    assert OLD_CMD in t, f"{f.name}: cmd palette not found"
    assert OLD_BIND in t, f"{f.name}: export bind not found"
    assert OLD_INIT in t, f"{f.name}: init hook not found"
    assert OLD_REMIND in t, f"{f.name}: reminder text not found"
    assert '.import-input{display:none}' in t, f"{f.name}: css anchor not found"
    t = t.replace(OLD_JS, NEW_JS)
    t = t.replace(OLD_BTN_EXPORT, NEW_BTN_EXPORT)
    t = t.replace(OLD_BTN_IMPORT, NEW_BTN_IMPORT)
    t = t.replace(OLD_CMD, NEW_CMD)
    t = t.replace(OLD_BIND, NEW_BIND)
    t = t.replace(OLD_INIT, NEW_INIT)
    t = t.replace(OLD_REMIND, NEW_REMIND)
    # 避免重复注入 CSS
    if '.backup-auto{' not in t:
        t = t.replace('.import-input{display:none}', '.import-input{display:none}'+CSS_ADD, 1)
    f.write_text(t, encoding='utf-8')
    print("OK", f.name)
print("DONE")
