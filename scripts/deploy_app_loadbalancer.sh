#!/bin/bash

kubectl apply -f deployments/deployment.my-flask-app.stable.yml --record
kubectl rollout status deployment flask-app-deployment-stable

kubectl apply -f deployments/deployment.my-flask-app.canary.yml --record
kubectl rollout status deployment flask-app-deployment-canary

kubectl apply -f deployments/service.loadbalancer.yml

kubectl get all --show-labels -l app=my-flask-app
