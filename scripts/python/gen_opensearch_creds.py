import re
import json
import pwinput

password_requirements = """
\nPassword must meet the following complexity requirements:
- Be at least 12 characters long
- Contain at least 1 uppercase letter
- Contain at least 1 lowercase letter
- Contain at least 1 digit
- Contain at least 1 special character like !@#$%^&*(),.?":}{|-<=_>/\\ \n
"""

def validate_password(password:str) -> bool:
    if len(password) < 12:
        print("Password must be at least 12 characters long.")
        return False
    if not re.search(r"[A-Z]", password):
        print("Password must contain at least one uppercase letter.")
        return False
    if not re.search(r"[a-z]", password):
        print("Password must contain at least one lowercase letter.")
        return False
    if not re.search(r"\d", password):
        print("Password must contain at least one number.")
        return False
    if not re.search(r"[^A-Za-z0-9]", password):
        print("Password must contain at least one special character.")
        return False
    return True

valid_password = ""

print(password_requirements)

while True:
    password = pwinput.pwinput(mask='*', prompt='Enter password: ')
    confirm_password = pwinput.pwinput(mask='*', prompt='Confirm password: ')

    if password != confirm_password:
        print("Passwords do not match. Try again.")
        continue

    if validate_password(password):
        valid_password = password
        break
    else:
       continue

data = {
    "password": valid_password
}

with open("./secrets/opensearch/credentials.json", 'w') as file:
    json_data = json.dumps(data, indent=4)
    file.write(json_data)

print("Your credentials were saved to ./secrets/opensearch/credentials.json")