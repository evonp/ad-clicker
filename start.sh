#!/bin/bash

# 配置代理设置（使用付费代理服务）
export PROXY_SERVER="us.proxy.example.com"  # 替换为您的代理服务器
export PROXY_PORT="3128"
export PROXY_USER="your_username"          # 替换为您的代理用户名
export PROXY_PASS="your_password"          # 替换为您的代理密码

# 设置代理环境变量
export HTTP_PROXY="http://${PROXY_USER}:${PROXY_PASS}@${PROXY_SERVER}:${PROXY_PORT}"
export HTTPS_PROXY="http://${PROXY_USER}:${PROXY_PASS}@${PROXY_SERVER}:${PROXY_PORT}"
export SOCKS_PROXY="socks5://${PROXY_USER}:${PROXY_PASS}@${PROXY_SERVER}:${PROXY_PORT}"

# 验证IP地址
verify_ip() {
    echo "🌍 Verifying IP location..."
    python3 -c "from proxy_manager import verify_ip; verify_ip()"
}

# 主执行流程
echo "🟢 Starting Ad Click System with Proxy"

# 验证IP最多尝试3次
for i in {1..3}; do
    if verify_ip; then
        break
    else
        echo "🔄 Retrying IP verification ($i/3)..."
        sleep 3
    done
done

echo "🟢 Ad Click System Started"
while true; do
    echo "⏰ Time to run a click"
    python3 main.py
    sleep $((RANDOM % 300 + 300))  # 5-10分钟随机间隔
done
