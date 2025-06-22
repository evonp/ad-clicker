import requests
from urllib3.util.retry import Retry
from requests.adapters import HTTPAdapter
import socks
from socket import AF_INET

def create_session():
    session = requests.Session()
    retry_strategy = Retry(
        total=5,
        backoff_factor=0.3,
        status_forcelist=[429, 500, 502, 503, 504]
    )
    adapter = HTTPAdapter(max_retries=retry_strategy)
    session.mount("http://", adapter)
    session.mount("https://", adapter)
    return session

def verify_ip():
    session = create_session()
    proxies = {
        'http': 'socks5://127.0.0.1:40000',
        'https': 'socks5://127.0.0.1:40000'
    }
    
    try:
        # 测试代理连接
        test_response = session.get(
            "https://www.cloudflare.com/cdn-cgi/trace", 
            proxies=proxies, 
            timeout=10
        )
        
        if "warp=on" not in test_response.text:
            print("⚠️ WARP not active in proxy connection")
            return False
        
        # 获取完整IP信息
        ip_response = session.get(
            "https://ipinfo.io/json", 
            proxies=proxies, 
            timeout=10
        )
        
        if ip_response.status_code == 200:
            data = ip_response.json()
            print(f"🌐 Current IP: {data.get('ip')} | Country: {data.get('country')}")
            return data.get('country') == 'US'
        else:
            print(f"⚠️ IP verification failed: HTTP {ip_response.status_code}")
            return False
            
    except Exception as e:
        print(f"⚠️ IP verification error: {str(e)}")
        return False
