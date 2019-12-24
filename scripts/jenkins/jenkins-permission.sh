#!/bin/bash

groupadd k8s
usermod -G k8s $1
usermod -G k8s jenkins
chgrp k8s $HOME/.kube/
chgrp k8s $HOME/.minikube/
chmod -R g+r $HOME/.kube/
chmod -R g+r $HOME/.minikube/