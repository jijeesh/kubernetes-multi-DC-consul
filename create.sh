#!/bin/bash


echo "Generating the Gossip encryption key..."

export GOSSIP_ENCRYPTION_KEY=$(consul keygen)


echo "Creating the Consul Secret to store the Gossip key and the TLS certificates..."

kubectl -n consul create secret generic consul \
  --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
  --from-file=certs/ca.pem \
  --from-file=certs/consul.pem \
  --from-file=certs/consul-key.pem


echo "Storing the Consul config in a ConfigMap..."

kubectl -n consul create configmap consul --from-file=server.json


echo "Creating the Consul Service..."

kubectl -n consul create -f service.yaml

echo "Create the Consul Service Account .."

kubectl -n consul create -f service-accounts.yaml

echo "Create the Consul Cluster roles .."

kubectl -n consul create -f cluster-roles.yaml

echo "Creating the Consul StatefulSet..."

kubectl -n consul create -f statefulset.yaml
