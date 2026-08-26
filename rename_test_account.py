import pathlib, re

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

OLD_NAME = "'rikchou@icloud.com':'测试账号'"
NEW_NAME = "'rikchou@icloud.com':'Onezero长沙河西王府井店'"

CSS_ANCHOR = ".account-email{font-size:11.5px;color:var(--text3);font-weight:500;word-break:break-all}"
CSS_INSERT = CSS_ANCHOR + "\n.account-type{display:none;align-self:flex-start;margin-top:1px;font-size:10.5px;font-weight:600;color:#d48806;background:rgba(212,136,6,.12);padding:1px 7px;border-radius:999px;letter-spacing:.02em}"

HTML_ANCHOR = '          <span class="account-name" id="accountName"></span>'
HTML_INSERT = HTML_ANCHOR + '\n          <span class="account-type" id="accountType"></span>'

JS_ANCHOR = "  var n=document.getElementById('accountName'); if(n) n.textContent=name;"
JS_INSERT = JS_ANCHOR + "\n  var t=document.getElementById('accountType'); if(t){ var isTest=SALARY_HIDDEN_EMAILS.indexOf(em.trim().toLowerCase())>=0; t.textContent=isTest?'测试账户':''; t.style.display=isTest?'inline-block':'none'; }"

for f in FILES:
    text = f.read_text(encoding='utf-8')
    assert OLD_NAME in text, f"{f.name}: NAME_MAP entry not found"
    assert CSS_ANCHOR in text, f"{f.name}: CSS anchor not found"
    assert HTML_ANCHOR in text, f"{f.name}: HTML anchor not found"
    assert JS_ANCHOR in text, f"{f.name}: JS anchor not found"
    # idempotency: don't double-insert
    assert 'accountType' not in text, f"{f.name}: accountType already present"
    assert NEW_NAME not in text, f"{f.name}: already renamed"

    text = text.replace(OLD_NAME, NEW_NAME, 1)
    text = text.replace(CSS_ANCHOR, CSS_INSERT, 1)
    text = text.replace(HTML_ANCHOR, HTML_INSERT, 1)
    text = text.replace(JS_ANCHOR, JS_INSERT, 1)

    f.write_text(text, encoding='utf-8')
    print(f"updated: {f.name}")
print("DONE")
