#!/bin/bash

# 启动WARP服务并等待就绪
start_warp() {
    echo "🔧 Starting WARP service..."
    warp-svc > /dev/null 2>&1 &
    local max_attempts=10
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if warp-cli --accept-tos status 2>/dev/null | grep -q "Status update: Connected"; then
            echo "🟢 WARP connected"
            return 0
        fi
        
        echo "⏳ Waiting for WARP to start (attempt $((attempt+1))/$max_attempts)..."
        sleep 3
        ((attempt++))
    done
    
    echo "❌ Failed to start WARP service"
    return 1
}

# 配置WARP客户端
configure_warp() {
    echo "⚙️ Configuring WARP client..."
    warp-cli --accept-tos register
    warp-cli --accept-tos set-mode proxy
    warp-cli --accept-tos connect
    sleep 5
}

# 验证IP地址
verify_ip() {
    echo "🌍 Verifying IP location..."
    python3 -c "from proxy_manager import verify_ip; verify_ip()"
}

# 主执行流程
if start_warp; then
    configure_warp
    
    # 验证IP最多尝试3次
    for i in {1..3}; do
        if verify_ip; then
            break
        else
            echo "🔄 Retrying IP verification ($i/3)..."
            sleep 3
        fi
    done
    
    echo "🟢 Ad Click System Started"
    while true; do
        echo "⏰ Time to run a click"
        python3 main.py
        sleep $((RANDOM % 300 + 300))  # 5-10分钟随机间隔
    done
else
    echo "❌ Critical error: WARP service failed to start"
    exit 1
fi
