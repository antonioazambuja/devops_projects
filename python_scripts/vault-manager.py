import requests
import sys
import base64
import argparse
import json


def get_args():
    parser = argparse.ArgumentParser(description="Vault Manager")
    parser.add_argument('--token',
                        type=str,
                        help="Vault Token.")
    parser.add_argument('--url',
                        type=str,
                        help="URL Vault.",
                        default="http://localhost:8200/")
    subparser = parser.add_subparsers(title="Actions", help="Actions supported by this script.")
    subparser.required=True
    parser_post = subparser.add_parser("post", help="Save secret in Vault.")
    parser_post.add_argument("--secret",
                             type=str,
                             help="Secret json to save in Vault")
    parser_post.add_argument("--namespace",
                             type=str,
                             help="Namespace to save to the Vault")
    parser_post.add_argument("--secretName",
                             type=str,
                             help="Secret name in the Vault")
    parser_post.set_defaults(func=post)
    parser_get = subparser.add_parser("get", help="Get secret in Vault.")
    parser_get.add_argument("--namespace",
                             type=str,
                             help="Namespace to get to the Vault")
    parser_get.add_argument("--secretName",
                             type=str,
                             help="Secret name in the Vault")
    parser_get.set_defaults(func=get)
    parser_delete = subparser.add_parser("delete", help="Delete secret in Vault.")
    parser_delete.add_argument("--namespace",
                             type=str,
                             help="Namespace to delete to the Vault secret")
    parser_delete.add_argument("--secretName",
                             type=str,
                             help="Secret name in the Vault")
    parser_delete.set_defaults(func=delete)
    args = parser.parse_args()
    args.func(args)


def post(args):
    vaultToken = base64.b64decode(bytes(args.token, 'UTF-8')).decode('UTF-8').rstrip()
    try:
        vaultUrl = args.url + "v1/secret/" + args.namespace + "/" + args.secretName
        headers = {
            "X-Vault-Token": vaultToken,
            "Content-Type": "application/json"
        }
        requests.post(vaultUrl, json=json.loads(args.secret), headers=headers)
    except Exception as error:
        print("[-] Exception: " + str(error))
        sys.exit(1)


def get(args):
    vaultToken = base64.b64decode(bytes(str(args.token), 'UTF-8')).decode('UTF-8').rstrip()
    try:
        vaultUrl = args.url + "v1/secret/" + args.namespace + "/" + args.secretName
        headers = {
            "X-Vault-Token": vaultToken
        }
        response = requests.get(vaultUrl, headers=headers)
        if response.status_code == 200:
            print(json.dumps(json.loads(response.content)["data"], indent=2))
    except Exception as error:
        print("[-] Exception: " + str(error) + "\n[-] Status code: ' + str(response.status_code)")
        sys.exit(1)


def delete(args):
    vaultToken = base64.b64decode(bytes(args.token, 'UTF-8')).decode('UTF-8').rstrip()
    try:
        vaultUrl = args.url + "v1/secret/" + args.namespace + "/" + args.secretName
        headers = {
            "X-Vault-Token": vaultToken
        }
        requests.delete(vaultUrl, headers=headers)
    except Exception as error:
        print("[-] Exception: " + str(error))
        sys.exit(1)


if __name__ == '__main__':
    get_args()

