#!/bin/bash

FLAG="/var/log/firstboot.log"
if [[ ! -f $FLAG ]]; then
   #Put here your initialization sentences
   echo "This is the first boot"
   PORTAINER_EDGE_ID=$(hostname)
   podman run -d \
     -v /run/podman/podman.sock:/var/run/docker.sock \
     -v /var/lib/containers/storage:/var/lib/docker/volumes \
     -v /:/host \
     -v portainer_agent_data:/data \
     --privileged \
     --pids-limit=0 \
     --restart always \
     -e EDGE=1 \
     -e EDGE_ID=$PORTAINER_EDGE_ID \
     -e EDGE_KEY=<REPLACE WITH PORTAINER EDGE KEY> \
     -e EDGE_INSECURE_POLL=1 \
     --name portainer_edge_agent \
     docker.io/portainer/agent:2.15.1
   #the next line creates an empty file so it won't run the next boot
   touch "$FLAG"
else
   echo "Do nothing"
fi
