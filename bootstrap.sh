#!/bin/bash

sudo apt update
sudo snap install kubectl --classic

sudo mkdir /home/ubuntu/.kube
sudo chown ubuntu:ubuntu /home/ubuntu/.kube
sudo snap install docker

sudo snap install microk8s --classic

sudo microk8s.config > ~/.kube/config
chmod 600 /home/ubuntu/.kube/config

sudo microk8s enable storage
sudo microk8s enable dns
sudo microk8s enable rbac

curl https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz -o helm.tar.gz
tar -xvzf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin

helm repo add jenkins https://charts.jenkins.io

helm install -f ./k8s/helm/jenkins/values.yaml  buildit-jenkins jenkins/jenkins

