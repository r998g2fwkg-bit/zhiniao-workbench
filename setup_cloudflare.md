# Cloudflare Pages 设置指南

## GitHub 仓库已创建
- 地址: https://github.com/r998g2fwkg-bit/zhiniao-workbench
- 状态: ✅ 已推送代码

## Cloudflare Pages 绑定步骤

### 方法1: 手动操作（推荐）
1. 打开 https://dash.cloudflare.com/?to=pages
2. 点击「Get started」或页面上的「Create project」
3. 选择第三个选项「Connect to Git」（Git分支图标）
4. 授权 Cloudflare 访问 GitHub
5. 选择仓库: `r998g2fwkg-bit/zhiniao-workbench`
6. 设置构建参数:
   - Build command: (留空)
   - Output directory: `/dist`
   - Base directory: (留空)
7. 点击「Save and Deploy」

### 方法2: 使用Cloudflare API（可选）
如果UI操作困难，可以使用API直接创建:
```bash
# 需要 Cloudflare Account ID 和 API Token
curl -X POST "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "zhiniao-workbench",
    "production_branch": "main",
    "source": {
      "type": "github"
    }
  }'
```

## 后续同步更新
修改代码后运行:
```bash
cd /Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01
./deploy_to_cloudflare.sh
```

这会:
1. 同步 dist/ 到 github-pages/
2. 推送到 GitHub
3. Cloudflare 自动重新部署
