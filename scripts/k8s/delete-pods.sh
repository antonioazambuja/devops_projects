#!/bin/bash

kubectl --kubeconfig /home/ilegra/.kube/config delete -f .
until kubectl --kubeconfig /home/ilegra/.kube/config get pods | grep "No resources found in default namespace."
do
    sleep 30
done
exit 0
