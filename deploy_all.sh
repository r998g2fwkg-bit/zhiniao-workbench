#!/bin/bash
# 知鸟工作台 - 双站同步部署脚本
set -e

echo "🚀 开始部署知鸟答案工作台..."
echo ""

cd /Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01

# 步骤 1: 构建最新产物
echo "📦 步骤 1/3: 构建最新产物..."
python3 build.py
echo "✅ 构建完成"
echo ""

# 步骤 2: 推送 GitHub + Cloudflare
echo "📤 步骤 2/3: 推送到 GitHub..."
./deploy_to_cloudflare.sh
echo ""

# 步骤 3: 部署 CloudBase 主站
echo "☁️ 步骤 3/3: 部署 CloudBase 主站..."
cd dist && tcb hosting deploy ./ -e zhiniao-d9goc0ztofee3fad2 > /dev/null 2>&1
echo "✅ CloudBase 主站部署完成"
echo ""

echo "🎉 双站部署完成！"
echo ""
echo "🌐 主站：https://zhiniao-d9goc0ztofee3fad2-1466502047.tcloudbaseapp.com"
echo "🌐 备用：https://zhiniao-workbench.pages.dev"
