# TCB 云托管 Node.js 20.x 基础镜像
FROM node:20-alpine

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm ci --only=production && npm cache clean --force

# 复制应用代码
COPY . .

# 创建日志目录
RUN mkdir -p logs

# 暴露端口 9000（TCB 云托管标准端口）
EXPOSE 9000

# 启动命令
CMD ["npm", "start"]

# 健康检查（可选）
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:9000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"
