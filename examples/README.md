# Examples
Deployment.yaml contains a deployment that will pull from a valid vault k8s setup from the /secret/foo key space 3 'types' of secrets:
1. Object mapping: ```
    {
      "type": ".env",
      "vault_secret_path": "secret/foo/.env",
      "output": "/output/.env"
    },
```
  This object tells knox to pull from secret path secret/foo/.env, translate all k/v pairs via iteration into `k=v` format and place at path /output.env

2.  Object mapping: ```
      {
        "type": "file",
        "vault_secret_path": "secret/foo/jwt",
        "key": "Key",
        "output": "/output/jwt"
      },
```
  This object tells knox to pull from secret path secret/foo/jwt, perform no tranlation ('file' type), and place the contents of the value found at  ` Key ` in /output/jwt
