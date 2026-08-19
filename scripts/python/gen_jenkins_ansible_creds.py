import bcrypt
import json
import pwinput
import os

username = input("Enter username: ")

password = pwinput.pwinput(mask='', prompt="Enter password: ")
password_bytes = password.encode("utf-8")
salt = bcrypt.gensalt()
hash = bcrypt.hashpw(password_bytes, salt).decode("utf-8")

jenkins_approle = None
container_registry_id = None

with open("./secrets/vault/approle/jenkins_approle.json", "r") as file:
    jenkins_approle = json.loads(file.read())

with open ("./secrets/jenkins/ycr_id", "r") as file:
    container_registry_id = file.read()

data = {
    "admin_username": username,
    "admin_password_hash": password,
    "jenkins_role_id": jenkins_approle["role_id"],
    "jenkins_secret_id": jenkins_approle["secret_id"],
    "ycr_id": container_registry_id
}

with open("./secrets/jenkins/credentials.json", 'w') as file:
    json_data = json.dumps(data, indent=4)
    file.write(json_data)

os.remove("./secrets/jenkins/ycr_id")

print("Your Jenkins credentials were saved to ./secrets/jenkins/credentials.json")