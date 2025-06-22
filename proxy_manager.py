import os
import subprocess
import requests

def setup_warp_proxy():
    """安装并配置WARP代理"""
    print("🔧 Setting up WARP proxy...")
    
    try:
        # 安装WARP
        commands = [
            "curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg",
            'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list',
            "apt-get update",
            "apt-get install -y cloudflare-warp"
        ]
        
        for cmd in commands:
            subprocess.run(cmd, shell=True, check=True)
        
        # 注册并启动WARP
        subprocess.run("warp-cli register", shell=True, check=True)
        subprocess.run("warp-cli set-mode proxy", shell=True, check=True)
        subprocess.run("warp-cli connect", shell=True, check=True)
        
        # 验证IP
        verify_ip()
        
    except Exception as e:
        print(f"⚠️ WARP setup failed: {e}")
        activate_backup_proxy()

def verify_ip():
    """验证IP是否为美国IP"""
    print("🌍 Verifying IP location...")
    try:
        response = requests.get("https://ipinfo.io/json", 
                               proxies={"https": "socks5://127.0.0.1:40000"},
                               timeout=10)
        data = response.json()
        country = data.get("country", "")
        print(f"Current IP: {data['ip']} | Country: {country}")
        
        if country != "US":
            raise Exception(f"IP is from {country}, not US")
    except Exception as e:
        print(f"⚠️ IP verification error: {e}")
        activate_backup_proxy()

def activate_backup_proxy():
    """激活备用代理方案"""
    print("🛡️ Activating backup proxy...")
    # 这里可以添加备用代理方案
    pass
