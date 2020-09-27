#!/bin/bash

docker image build -t flask-app-image:1.0.0 -f ./Dockerfile .
docker images -f label=NAME=flask-app-image
