### Grafana stack to run on kubernetes

Requires the ``monitoring`` namespace on the cluster before deployment

    kubectl create namespace monitoring

### API calls examples

#### adding environment tags
this API call adds the tag ``humidity``

```
#!/bin/bash

curl --request POST \
--insecure \
--write-out "%{http_code}" \
--header 'Content-Type: application/json' \
--header 'x-api-key: ptr_fr2mXQ7uncsotIhELoiuK5vq4N766dATsNkZhFp6myM=' \
--url 'https://192.168.10.6:9443/api/tags' --data '{"name": "humidity"}'
```

#### adding the humidity tags to specific devices
this API call adds the ``humidity`` tag to specific devices

```
#!/bin/bash

# Variables
jwt=`http --verify=no --ignore-stdin POST https://192.168.10.6:9443/api/auth Username="adelorenzo" Password="dimi2014" | jq '.jwt' | sed 's/^.//' | sed 's/.$//'`
access="ptr_fr2mXQ7uncsotIhELoiuK5vq4N766dATsNkZhFp6myM="
edge_group_id=`http --verify=no GET https://192.168.10.6:9443/api/endpoint_groups "Authorization: Bearer $jwt" | jq -c '.[] | select( .Name == "edge" ) | .Id'`
humidity_tag=`http --verify=no GET https://192.168.10.6:9443/api/tags "Authorization: Bearer $jwt" | jq -c '.[] | select( .Name == "humidity" ) | .ID'`

# Update the humidity tag
for i in {000..014}
do
  humidity_endpoint=`http --verify=no GET https://192.168.10.6:9443/api/endpoints "Authorization: Bearer $jwt" | jq -c '.[] | select( .Type == 4 ) | .Name,.Id' | paste - - | grep humidity-edge5$i | awk '{ print $2 }'`
  echo curl --request PUT --insecure --write-out \"%{http_code}\" --header \'Content-Type: application/json\' --header \'x-api-key: ptr_fr2mXQ7uncsotIhELoiuK5vq4N766dATsNkZhFp6myM=\' --url \'https://192.168.10.6:9443/api/endpoints/$humidity_endpoint\' --data \'{\"TagIds\": ["$humidity_tag"]\, \"GroupID\":"$edge_group_id"}\' > tag_add.sh
  chmod +x ./tag_add.sh
  ./tag_add.sh
done
```
