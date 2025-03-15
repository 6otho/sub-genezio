#!/bin/sh
# 创建数据目录
mkdir -p /opt/app/data
cd /opt/app/data

# 启动 http-meta 服务（后台运行，并记录日志）
META_FOLDER=/opt/app/http-meta HOST=:: node /opt/app/http-meta.bundle.js > /opt/app/data/http-meta.log 2>&1 & 
echo "HTTP-META is running..."

# 启动 Sub-Store 服务
SUB_STORE_BACKEND_API_HOST=:: \
SUB_STORE_FRONTEND_HOST=:: \
SUB_STORE_FRONTEND_PORT=3001 \
SUB_STORE_FRONTEND_PATH=/opt/app/frontend \
SUB_STORE_DATA_BASE_PATH=/opt/app/data \
node /opt/app/sub-store.bundle.js
