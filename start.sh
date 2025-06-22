#!/bin/bash

# 启动 WARP 服务
echo "🔧 Starting WARP service..."
warp-svc > /dev/null 2>&1 &

# 等待服务启动
sleep 5

# 配置 WARP 客户端
warp-cli register
warp-cli set-mode proxy
warp-cli connect

# 等待连接建立
sleep 3

# 验证 IP
python3 -c "from proxy_manager import verify_ip; verify_ip()"

# 启动主程序
python3 main.py 
