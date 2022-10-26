### Grafana stack to run on kubernetes

Requires the ``monitoring`` namespace on the cluster before deployment

    kubectl create namespace monitoring

### API calls examples

#### adding edge tags
this API call adds the tag ``humidity`` to devices

```
#!/bin/bash

curl --request POST \
--insecure \
--write-out "%{http_code}" \
--header 'Content-Type: application/json' \
--header 'x-api-key: ptr_fr2mXQ7uncsotIhELoiuK5vq4N766dATsNkZhFp6myM=' \
--url 'https://192.168.10.6:9443/api/tags' --data '{"name": "humidity"}'
```
