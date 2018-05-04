# knox
Script for pushing Hashicorp Vault secrets to kubernetes


The configmap tells knox what to do with a secret.

## config mapping
| Key | Description | example
| --- | --- | --- |
| type | Processor for knox to use | ` .env ` |
| secret | Path to secret | ` secret/foo/bar ` |
| key | The key to prcoess within a secret (not used on .env type) | ` mysql_password ` |
| output | Absolute path to output to. Mount must already exists | ` /output/.env ` |

## types

| Name | description |
| --- | --- |
| .env | Iterate over all the K/V in a secret and convert them to a file of format k=v |
| file | Take the contents of the secret at key ` "key" ` and output to a file ` "output" ` |
| decode_base64 | Take the contents of the ` "secret" ` at key ` "key" ` base64decode the secret and output to a file ` "output" ` |

## Example config
```
    [
      {
        "type": ".env",
        "secret": "secret/foo/.env",
        "output": "/output/.env"
      },
      {
        "type": "file",
        "secret": "secret/foo/jwts",
        "key": "example",
        "output": "/output/example"
      },
      {
        "type": "file",
        "secret": "secret/foo/certificates",
        "key": "example_plaintext_cert",
        "output": "/output/example_plaintext_cert.pem"
      },
      {
        "type": "decode_base64",
        "secret": "secret/foo/certificates",
        "key": "example_base64_cert",
        "output": "/output/example_base64_cert.pem"
      }
    ]
```

# Examples
See [examples directory](examples/)
