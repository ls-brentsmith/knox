# Examples
deployment.yaml contains a working example of a k8s deployment that will mount secrets from a valid Vault server with a working k8s auth backend.

# Prerequisites
- working Vault server
- enabled kubernetes auth
- valid vault role for your cluster / namespace / service account
- secrets exists that are defined in the configmap

In the example a role 'foo' is allowed to read secrets at secret/foo/

` kubectl apply -f examples/ `
