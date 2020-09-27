#!/bin/bash

kubectl apply -f deployments/deployment.my-flask-app.yml --record
kubectl apply -f deployments/deployment.service.nodeport.yml

kubectl rollout status deployment flask-app-deployment
kubectl get all --show-labels -l app=my-flask-app
