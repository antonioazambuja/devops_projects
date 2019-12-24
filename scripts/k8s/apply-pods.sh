#!/bin/bash

kubectl --kubeconfig /home/ilegra/.kube/config apply -f .
until kubectl --kubeconfig /home/ilegra/.kube/config get pods | grep "your-pod" | grep "Running"
do
    sleep 30
done
exit 0
