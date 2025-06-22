import requests
import subprocess

def verify_ip():
    """验证 IP 是否为美国 IP"""
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
        # 尝试重新连接 WARP
        print("🔄 Reconnecting WARP...")
        subprocess.run("warp-cli disconnect", shell=True)
        subprocess.run("warp-cli connect", shell=True)
