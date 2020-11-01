#!/bin/bash

VERSION=
while getopts "sc" arg; do
    case ${arg} in
        s)
            VERSION="stable"
            ;;
        c)
            VERSION="canary"
            ;;
        *)
            echo "Invalid version=${arg} specified."
            exit 1
    esac
done
if [ -z ${VERSION} ]
then
    echo "Specify -s (for STABLE) or -c (for CANARY)"
    exit 1
fi

kubectl apply -f deployments/deployment.my-flask-app.${VERSION}.yml --record
kubectl apply -f deployments/service.nodeport.yml

kubectl rollout status deployment flask-app-deployment-${VERSION}
kubectl get all --show-labels -l app=my-flask-app
