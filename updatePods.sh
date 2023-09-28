#!/bin/bash

ip=$(kubectl get svc api-service -o jsonpath='{..ip}')

echo $ip


filename="configmaps/services-configmap.yaml"

replace="\ \ api_service_url: http://$ip/api"

echo $replace

sed -i "/api_service_url:/c $replace" $filename

echo "updating configMap"

kubectl apply -f configmaps/services-configmap.yaml

echo "Restarting pods"

kubectl delete --all pods

echo "Restart SuccessFull"





