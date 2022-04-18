import requests
from datetime import datetime

payload = {
    "queryParams" : {},
    "optIntoOneTap" : "false",
    "username" : "sudopacmandeleteme",
    "enc_password" : f"#PWD_INSTAGRAM_BROWSER:0:{int(datetime.now().timestamp())}:sudopacmandeleteme"
}

while True:
    response = requests.post("https://instagram.com/accounts/login/ajax/",data=payload)
    print(response.status_code)
#cookie_request = requests.get("https://insta
