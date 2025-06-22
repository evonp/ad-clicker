#!/bin/bash

# 启动 WARP 代理（带重试）
for i in {1..5}; do
    warp-cli register && \
    warp-cli set-mode proxy && \
    warp-cli connect && \
    break || sleep 10
done

# 验证 IP
python -c "from proxy_manager import verify_ip; verify_ip()"

# 启动主程序
python main.py
