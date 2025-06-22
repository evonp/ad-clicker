FROM python:3.10-slim-bullseye

WORKDIR /app

# 安装系统依赖（包括 SOCKS 支持）
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    lsb-release \
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
    libasound2 \
    pkg-config \
    libssl-dev \  # 添加 SOCKS 依赖
    python3-dev \ # 添加 Python 开发工具
    build-essential

# 安装 WARP（使用硬编码的发行版名称）
RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bullseye main" | tee /etc/apt/sources.list.d/cloudflare-client.list && \
    apt-get update && \
    apt-get install -y cloudflare-warp

# 复制应用文件（使用 COPY --chmod 设置权限）
COPY --chmod=755 . .

# 安装 Python 依赖（包括 SOCKS 支持）
RUN pip install --no-cache-dir -r requirements.txt pysocks

# 安装 Playwright 浏览器
RUN python -m playwright install chromium

# 启动脚本
CMD ["/bin/bash", "-c", "dos2unix start.sh && ./start.sh"]
