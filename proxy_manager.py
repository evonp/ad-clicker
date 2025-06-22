import requests
import os
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
    
    # 自动检测代理设置
    proxy_settings = {}
    if os.environ.get('HTTP_PROXY'):
        proxy_settings['http'] = os.environ.get('HTTP_PROXY')
    if os.environ.get('HTTPS_PROXY'):
        proxy_settings['https'] = os.environ.get('HTTPS_PROXY')
    if os.environ.get('SOCKS_PROXY'):
        proxy_settings['http'] = os.environ.get('SOCKS_PROXY')
        proxy_settings['https'] = os.environ.get('SOCKS_PROXY')
    
    session.proxies = proxy_settings
    return session

def verify_ip():
    session = create_session()
    
    try:
        # 获取IP信息
        ip_response = session.get(
            "https://ipinfo.io/json", 
            timeout=10
        )
        
        if ip_response.status_code == 200:
            data = ip_response.json()
            print(f"🌐 Current IP: {data.get('ip')} | Country: {data.get('country')}")
            
            # 检查是否为美国IP
            if data.get('country') == 'US':
                return True
            else:
                print("⚠️ Proxy is not providing US IP address")
                return False
        else:
            print(f"⚠️ IP verification failed: HTTP {ip_response.status_code}")
            return False
            
    except Exception as e:
        print(f"⚠️ IP verification error: {str(e)}")
        return False
