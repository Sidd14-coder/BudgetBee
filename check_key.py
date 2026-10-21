import urllib.request
import json
import ssl

ssl._create_default_https_context = ssl._create_unverified_context
api_key = 'AIzaSyDNq98N83RwBI2MaO1dbUVpDRhiqGox2_o'
url = f'https://generativelanguage.googleapis.com/v1beta/models?key={api_key}'

try:
    req = urllib.request.Request(url)
    res = urllib.request.urlopen(req).read().decode('utf-8')
    data = json.loads(res)
    models = [m.get('name') for m in data.get('models', []) if 'generateContent' in m.get('supportedGenerationMethods', [])]
    with open('key_models.txt', 'w') as f:
        for m in models:
            f.write(m + '\n')
except Exception as e:
    with open('key_models.txt', 'w') as f:
        f.write(f"Error checking API key: {e}\n")
