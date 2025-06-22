import requests
import subprocess

def verify_ip():
    """验证 IP 是否为美国 IP"""
    print("🌍 Verifying IP location...")
    try:
        # 使用 SOCKS 代理
        proxies = {
            'http': 'socks5://127.0.0.1:40000',
            'https': 'socks5://127.0.0.1:40000'
        }
        
        response = requests.get("https://ipinfo.io/json", proxies=proxies, timeout=10)
        data = response.json()
        country = data.get("country", "")
        print(f"Current IP: {data['ip']} | Country: {country}")
        
        if country != "US":
            raise Exception(f"IP is from {country}, not US")
    except Exception as e:
        print(f"⚠️ IP verification error: {e}")
        # 重启 WARP 服务
        print("🔄 Restarting WARP service...")
        subprocess.run("warp-cli disconnect", shell=True)
        subprocess.run("warp-cli connect", shell=True)
        # 重试验证
        verify_ip()
