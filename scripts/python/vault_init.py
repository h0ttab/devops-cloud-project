import requests
import argparse
import json
import logging as log

log.basicConfig(level=log.INFO, format='%(levelname)s :: %(message)s\n',)

arg_parser = argparse.ArgumentParser(description='HashiCorp Vault auto unseal script')
arg_parser.add_argument('host', help='Target Vault host IP')
arg_parser.add_argument('-p', '--port', default=8200, help='Target Vault host API port')
args = arg_parser.parse_args()

VAULT_IP = args.host
VAULT_PORT = args.port
VAULT_INIT_FILE_PATH = './secrets/vault/vault_bootstrap_keys.json'
VAULT_API_URL = f'http://{VAULT_IP}:{VAULT_PORT}/v1'

SECRET_SHARES = 12
SECRET_THRESHOLD = 10


def get_initialization_status() -> bool:
    log.info('Fetching Vault initialization status...')
    r = requests.get(url=f'{VAULT_API_URL}/sys/init')
    data = r.json()
    if 'initialized' not in data:
        log.error(f'Vault initialization status is unknown. Response from the server: {data}')
        exit(1)
    return data['initialized']


def initialize_vault(initialized: bool) -> None:
    if initialized:
        log.info('Vault is already initialized')
        return

    log.info('Vault is not initialized. Initializing now...')

    payload = {
        'secret_shares': SECRET_SHARES,
        'secret_threshold': SECRET_THRESHOLD
    }

    log.info('Sending initialization request')
    r = requests.post(f'{VAULT_API_URL}/sys/init', json=payload)
    r_json = r.json()

    if 'errors' in r_json:
        log.error(f'Error while initializing Vault: {r_json['errors']}')
        exit(1)

    data = json.dumps(r_json, indent=4, sort_keys=True)
    with open(VAULT_INIT_FILE_PATH, 'w') as file:
        file.write(data)
    with open('./secrets/vault/vault_root_token', 'w') as file:
        file.write(r_json['root_token'])
    log.info(f'Vault initialized! Bootstrap keys saved to {VAULT_INIT_FILE_PATH}')


def get_seal_status() -> bool:
    log.info('Fetching Vault seal status')
    r = requests.get(f'{VAULT_API_URL}/sys/seal-status')
    data = r.json()
    if 'sealed' not in data:
        log.error(f'Vault seal status is unknown. Response: {data}')
        exit(1)
    return data['sealed']


def get_bootstrap_keys(path: str) -> list[str]:
    log.info('Loading Vault keys...')
    with open(path, 'r') as file:
        data = file.read()
        return json.loads(data)


def unseal_vault(secret_share: str, share_index: int, shares_required: int, total_shares: int) -> None:
    log.info(
        f'Unsealing Vault using secret share №{share_index} out of {shares_required} required. Total shares issued: {total_shares}')

    payload = json.dumps({'key': secret_share})
    response = requests.put(f'{VAULT_API_URL}/sys/unseal', payload)
    data = response.json()

    if 'errors' in data or 'sealed' not in data:
        log.error(f'Error while unsealing Vault: {data['errors']}')


if __name__ == '__main__':
    is_initialized = get_initialization_status()
    initialize_vault(is_initialized)
    seal_status = get_seal_status()

    if seal_status is False:
        log.info('Vault is already unsealed. Exiting...')
        exit(0)

    secret_shares = get_bootstrap_keys(VAULT_INIT_FILE_PATH)['keys']

    i = 1
    for key in secret_shares:
        unseal_vault(key, i, SECRET_THRESHOLD, SECRET_SHARES)

        i += 1
        if i > SECRET_THRESHOLD:
            break

    if get_seal_status() is False:
        log.info('Vault unsealed successfully. Exiting...')
    else:
        log.error('Failed to unseal vault. Exiting...')