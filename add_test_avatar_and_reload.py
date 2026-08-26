import re, pathlib

ROOT = pathlib.Path('/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01')
FILES = [ROOT/'知鸟答案工作台.html', ROOT/'dist/index.html', ROOT/'dist/index.static.html']

for p in FILES:
    text = p.read_text(encoding='utf-8')
    orig = text

    # 1. 给 hello-avatar 加点击刷新
    text = text.replace(
        '<img class="hello-avatar" id="helloAvatar" alt="">',
        '<img class="hello-avatar" id="helloAvatar" alt="头像" title="点击强制刷新" onclick="location.reload(true)" style="cursor:pointer">'
    )

    # 2. 给 account-avatar 加点击刷新
    text = text.replace(
        '<img class="account-avatar" id="accountAvatar" src="" alt="头像" />',
        '<img class="account-avatar" id="accountAvatar" src="" alt="头像" title="点击强制刷新" onclick="location.reload(true)" style="cursor:pointer" />'
    )

    # 3. 给 USER_AVATARS 追加 rikchou@icloud.com（兼容单行/多行格式；
    #    若已存在则正则不会命中末尾，不会重复添加）
    text = re.sub(
        r"('3150971652@qq\.com':'assets/avatars/3150971652@qq\.com\.jpg')(\s*\}\s*;)",
        r"\1,\n  'rikchou@icloud.com':'assets/avatars/rikchou@icloud.com.png'\2",
        text
    )

    if text != orig:
        p.write_text(text, encoding='utf-8')
        print(f'  {p}: updated')
    else:
        print(f'  {p}: unchanged')

print('Done.')
