#!/bin/sh
set -e

# 创建 data 目录，用于存放日志和数据（当前目录下，不需要特殊权限）
mkdir -p data

# 下载 http-meta.bundle.js 文件（如果不存在）
if [ ! -f http-meta.bundle.js ]; then
  echo "Downloading http-meta.bundle.js..."
  curl -L -o http-meta.bundle.js https://github.com/xream/http-meta/releases/latest/download/http-meta.bundle.js
fi

# 下载 tpl.yaml 文件（放在 http-meta 目录下）
mkdir -p http-meta
if [ ! -f http-meta/tpl.yaml ]; then
  echo "Downloading tpl.yaml..."
  curl -L -o http-meta/tpl.yaml https://github.com/xream/http-meta/releases/latest/download/tpl.yaml
fi

# 下载 sub-store.bundle.js 文件（如果不存在）
if [ ! -f sub-store.bundle.js ]; then
  echo "Downloading sub-store.bundle.js..."
  curl -L -o sub-store.bundle.js https://github.com/sub-store-org/Sub-Store/releases/latest/download/sub-store.bundle.js
fi

# 下载前端文件并解压（如果 frontend 目录不存在）
if [ ! -d frontend ]; then
  echo "Downloading frontend dist.zip..."
  curl -L -o dist.zip https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip
  unzip dist.zip
  mv dist frontend
  rm dist.zip
fi

# 启动 http-meta 服务（后台运行，并将日志写入 data/http-meta.log）
echo "Starting HTTP-META..."
node http-meta.bundle.js > data/http-meta.log 2>&1 &
echo "HTTP-META is running..."

# 启动 Sub-Store 服务
echo "Starting Sub-Store..."
SUB_STORE_BACKEND_API_HOST=:: \
SUB_STORE_FRONTEND_HOST=:: \
SUB_STORE_FRONTEND_PORT=3001 \
SUB_STORE_FRONTEND_PATH=./frontend \
SUB_STORE_DATA_BASE_PATH=./data \
node sub-store.bundle.js
