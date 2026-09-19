#!/bin/bash
VAULT_IP=$1

if [[ -z "$VAULT_IP" ]]; then
    echo "Vault server IP must be specified as a parameter"
    exit 1
fi

echo "Cleaning local Vault secrets..."
rm -f ./secrets/vault/vault_bootstrap_keys.json
rm -f ./secrets/vault/vault_root_token
rm -f ./secrets/vault/vault_admin_credentials.json
rm -f ./secrets/vault/approle/terraform_approle.json
rm -f ./secrets/vault/approle/jenkins_approle.json
rm -f ./terraform/vault/terraform.tfstate*

echo "Stopping container and wiping remote storage on $VAULT_IP..."
ssh -o StrictHostKeyChecking=no ubuntu@$VAULT_IP -i ./secrets/ssh/cloud_ssh_key \
  'docker rm -f vault 2>/dev/null || true; sudo rm -rf /opt/vault_data/' &> /dev/null

echo "Rerunning base Ansible playbook..."
(
    cd ./ansible && ansible-playbook main.yaml
)

echo "Vault reset completed!"