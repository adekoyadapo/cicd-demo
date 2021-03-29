#!/bin/bash

echo -e '#############################'
echo -e 'Creating Registry for images'
k3d registry create dev.localhost --port 55000

echo -e '#############################'
echo -e 'Creating Cluster'
k3d cluster create --agents 1 --servers 1 -p 8000:80@loadbalancer --image rancher/k3s:v1.20.4-k3s1 k3d --registry-use=k3d-dev.localhost:55000

sleep 120
echo -e '#############################'
echo -e 'Adding Gitea charts'
helm repo add gitea-charts https://dl.gitea.io/charts/
helm repo update
kubectl create ns gitea

echo -e '#############################'
echo -e 'Installing Gitea via helm'
helm install gitea gitea-charts/gitea --namespace gitea --values=gitea.yml
kubectl apply of gitea-k3d.yml

echo -e '#############################'
echo -e 'Adding Jenkins charts'
helm repo add jenkinsci https://charts.jenkins.io
helm repo update

kubectl create namespace jenkins
