import os

dir_list = ["./secrets/cloud", "./secrets/jenkins", "./secrets/ssh", "./secrets/vault/approle"]

for dir_path in dir_list:
    os.makedirs(exist_ok=True, name=dir_path)

print("Secrets directories structure generated successfully")