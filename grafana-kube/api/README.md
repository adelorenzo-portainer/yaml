### API calls examples
The examples below require setting the following environment variables:

- $PORTAINER_SERVER_IP: the IP address of the Portainer server
- $ADMIN: the admin user of the Portainer server
- $PASSWORD: the password of the admin user of the Portainer server
- $API_KEY: the private API key for the admin user of the Portainer server. This key can be generated here:

#### Step one - access account
![Access account](https://github.com/adelorenzo-portainer/yaml/blob/main/grafana-kube/api/images/my_account.png?raw=true)
#### Step two - click on 'Add acess token' button
![Add access token](https://github.com/adelorenzo-portainer/yaml/blob/main/grafana-kube/api/images/access_token1.png?raw=true)
#### Step three - token created - makes sure to copy the access token before closing the creation window. It will only appear once.
![Token created](https://github.com/adelorenzo-portainer/yaml/blob/main/grafana-kube/api/images/access_token2.png?raw=true)


#### adding environment tags
this API call adds the tag ``humidity``

```
#!/bin/bash

curl --request POST \
--insecure \
--write-out "%{http_code}" \
--header 'Content-Type: application/json' \
--header 'x-api-key: $API_KEY' \
--url 'https://$PORTAINER_SERVER_IP:9443/api/tags' --data '{"name": "humidity"}'
```

#### adding the humidity tags to specific devices
this API call adds the ``humidity`` tag to specific devices

```
#!/bin/bash

# Variables
jwt=`http --verify=no --ignore-stdin POST https://$PORTAINER_SERVER_IP:9443/api/auth Username="$ADMIN" Password="$PASSWORD" | jq '.jwt' | sed 's/^.//' | sed 's/.$//'`
access="$API_KEY"
edge_group_id=`http --verify=no GET https://$PORTAINER_SERVER_IP:9443/api/endpoint_groups "Authorization: Bearer $jwt" | jq -c '.[] | select( .Name == "edge" ) | .Id'`
humidity_tag=`http --verify=no GET https://$PORTAINER_SERVER_IP:9443/api/tags "Authorization: Bearer $jwt" | jq -c '.[] | select( .Name == "humidity" ) | .ID'`

# Update the humidity tag
for i in {000..014}
do
  humidity_endpoint=`http --verify=no GET https://$PORTAINER_SERVER_IP:9443/api/endpoints "Authorization: Bearer $jwt" | jq -c '.[] | select( .Type == 4 ) | .Name,.Id' | paste - - | grep humidity-edge5$i | awk '{ print $2 }'`
  echo curl --request PUT --insecure --write-out \"%{http_code}\" --header \'Content-Type: application/json\' --header \'x-api-key: $API_KEY\' --url \'https://$PORTAINER_SERVER_IP:9443/api/endpoints/$humidity_endpoint\' --data \'{\"TagIds\": ["$humidity_tag"]\, \"GroupID\":"$edge_group_id"}\' > tag_add.sh
  chmod +x ./tag_add.sh
  ./tag_add.sh
done
```

