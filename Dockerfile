# 使用更可靠的基础镜像
FROM ubuntu:22.04

# 安装 Python 和基本工具
RUN apt-get update && \
    apt-get install -y python3.10 python3-pip curl gpg

# 设置工作目录
WORKDIR /app

# 安装浏览器依赖
RUN apt-get install -y \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2

# 安装 WARP（使用 Ubuntu 专用方法）
RUN curl https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ jammy main" | tee /etc/apt/sources.list.d/cloudflare-client.list && \
    apt-get update && \
    apt-get install -y cloudflare-warp

# 复制应用文件
COPY . .

# 安装 Python 依赖
RUN pip3 install --no-cache-dir -r requirements.txt

# 安装 Playwright 浏览器
RUN python3 -m playwright install chromium

# 启动脚本
CMD ["bash", "start.sh"]
