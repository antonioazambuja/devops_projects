#!/bin/bash

function run {
    minikube start
    kubectl config use-context minikube
    eval $(minikube docker-env)
}

function stop {
    eval $(minikube docker-env -u)
    minikube stop
    minikube delete
}

case $1 in
     "run")
          run
          ;;
     "stop")
          stop
          ;;
     "*")
          echo "Function not found!"
esac