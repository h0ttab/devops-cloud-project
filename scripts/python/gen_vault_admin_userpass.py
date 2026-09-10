import bcrypt
import json
import pwinput
username = input("Enter username: ")

password_bytes = pwinput.pwinput(mask='', prompt='Enter password:').encode("utf-8")
salt = bcrypt.gensalt()
hash = bcrypt.hashpw(password_bytes, salt).decode("utf-8")

data = {
    "username": username,
    "password_hash": hash
}

with open("./secrets/vault/vault_admin_credentials.json", 'w') as file:
    json_data = json.dumps(data, indent=4)
    file.write(json_data)

print("Your credentials were saved to ./secrets/vault/vault_admin_credentials.json")