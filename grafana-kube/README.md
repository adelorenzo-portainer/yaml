### Grafana stack to run on kubernetes

Requires the ``monitoring`` namespace on the cluster before deployment

    kubectl create namespace monitoring


The ``all-in-one.yaml`` can be used to deploy the entire stack

    kubectl apply -f all-in-one.yaml
