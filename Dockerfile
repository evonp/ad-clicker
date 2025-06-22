FROM python:3.10-slim-bullseye

# 设置工作目录
WORKDIR /app

# 安装基础系统依赖（包括 lsb-release）
RUN apt-get update && \
    apt-get install -y \
    curl gpg \
    lsb-release \  # 添加这个关键包
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 \
    libxrandr2 libgbm1 libasound2

# 安装 WARP（使用硬编码的发行版名称）
RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bullseye main" | tee /etc/apt/sources.list.d/cloudflare-client.list && \
    apt-get update && \
    apt-get install -y cloudflare-warp

# 复制应用文件
COPY . .

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 安装 Playwright 浏览器
RUN python -m playwright install chromium

# 启动脚本
CMD ["bash", "start.sh"]
