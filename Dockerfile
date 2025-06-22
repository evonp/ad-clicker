FROM python:3.10-slim-bullseye

# 安装核心依赖
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
    libssl-dev \
    python3-dev \
    build-essential \
    dos2unix \
    net-tools \  # 新增网络工具
    iproute2 \   # 新增IP路由工具
    procps       # 新增进程管理工具

# 安装 WARP
RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bullseye main" | tee /etc/apt/sources.list.d/cloudflare-client.list && \
    apt-get update && \
    apt-get install -y cloudflare-warp

WORKDIR /app
COPY . .

# 修复权限和换行符
RUN chmod 755 start.sh && \
    dos2unix start.sh

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt pysocks

# 安装浏览器
RUN python -m playwright install chromium

# 启动命令
CMD ["./start.sh"]
