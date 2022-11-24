"""Test SQL Injection attack referred in https://community.f5.com/t5/technical-articles/mitigating-owasp-top-10-a03-2021-injection-exploits-using/ta-p/296014."""

import requests

pub_dns = "domain-name.com"

# below post data is used to bypass user authorization even with incorrect password
login_post_data = {
    "email": "' OR true --",
    "password": "password"
}

headers = {'Content-type': 'application/json'}


def test_application():
    """Validate if application is running."""
    out = requests.get(pub_dns)
    if "OWASP Juice Shop" in out.text:
        print("=================================  Application is running.  ====================================")
    else:
        print("=================================  Application is not running.  ================================")


def test_injection_attack():
    """Test Injection attack."""
    url = pub_dns + "/rest/user/login"
    blocked = False
    for iter_num in range(5):
        out = requests.post(url, json=login_post_data, headers=headers)        
        if "Your support ID" in out.text:
            print(out.text)
            print("=================================  SQL Injection attack blocked successfully.  ==========="
                  "=========================")
            blocked = True
            break
    if not blocked:
        print("===================  SQL Injection attack not blocked, please check your configs, ==========="
              "=========================")


test_application()
test_injection_attack()
