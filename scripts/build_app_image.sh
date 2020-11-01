#!/bin/bash

docker image build -t my-flask-app-image:stable -f deployments/my-flask-app.stable.dockerfile .
docker image build -t my-flask-app-image:canary -f deployments/my-flask-app.canary.dockerfile .

echo "-------------"
docker images -f label=NAME=my-flask-app-image
