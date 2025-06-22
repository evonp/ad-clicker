#!/bin/bash

# 启动 WARP 代理
warp-cli register
warp-cli set-mode proxy
warp-cli connect

# 验证 IP
python3 -c "from proxy_manager import verify_ip; verify_ip()"

# 启动主程序
python3 main.py
# 添加空行确保文件以 LF 结尾
