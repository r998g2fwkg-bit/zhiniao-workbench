const fs=require("fs");
const files=["知鸟答案工作台.html","dist/index.html","dist/index.static.html"];
let ok=true;
for(const f of files){
  const s=fs.readFileSync(f,"utf8");
  const re=/<script\b[^>]*>([\s\S]*?)<\/script>/gi; let m,errs=0,n=0;
  while((m=re.exec(s))){n++; if(!m[1].trim())continue; try{new Function(m[1]);}catch(e){errs++; console.log(f,"SYNTAX ERR:",e.message.slice(0,80));}}
  const hasEnh=s.includes("isEnhancedVoice");
  console.log(f,"| scripts:",n,"| syntax errors:",errs,"| isEnhancedVoice present:",hasEnh);
  if(errs||!hasEnh) ok=false;
}
const getFn=(s)=>{const i=s.indexOf("function isEnhancedVoice");const j=s.indexOf("function applyVoiceTo");return s.slice(i,j);};
const a=getFn(fs.readFileSync("知鸟答案工作台.html","utf8"));
const b=getFn(fs.readFileSync("dist/index.html","utf8"));
const c=getFn(fs.readFileSync("dist/index.static.html","utf8"));
console.log("three-ends identical for voice block:", a===b && b===c);
console.log("ALL OK:", ok && a===b && b===c);
