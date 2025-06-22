#!/bin/bash

# 启动 WARP 代理
warp-cli register && \
warp-cli set-mode proxy && \
warp-cli connect

# 验证 IP
python -c "from proxy_manager import verify_ip; verify_ip()"

# 启动主程序
python main.py
