#!/bin/bash

# 安装浏览器依赖
apt-get update
apt-get install -y libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2

# 设置 WARP 代理
python3 -c "from proxy_manager import setup_warp_proxy; setup_warp_proxy()"

# 启动主程序
python3 main.py
