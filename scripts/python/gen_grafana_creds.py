import json
import pwinput
username = input("Enter username: ")

password = pwinput.pwinput(mask='', prompt='Enter password:')

data = {
    "username": username,
    "password": password
}

with open("./secrets/grafana/credentials.json", 'w') as file:
    json_data = json.dumps(data, indent=4)
    file.write(json_data)

print("Your credentials were saved to ./secrets/grafana/credentials.json")