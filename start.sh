#!/bin/bash

# 安装系统依赖
sudo apt-get update
sudo apt-get install -y curl gpg libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2

# 安装浏览器依赖
python -m playwright install-deps

# 安装 Playwright 浏览器
python -m playwright install chromium

# 设置 WARP 代理
python -c "from proxy_manager import setup_warp_proxy; setup_warp_proxy()"

# 启动主程序
python main.py
