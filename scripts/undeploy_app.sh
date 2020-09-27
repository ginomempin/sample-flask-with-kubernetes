#!/bin/bash

kubectl delete service,deployment -l app=my-flask-app
