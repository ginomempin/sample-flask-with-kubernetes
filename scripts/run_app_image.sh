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


echo "Deleting existing containers..."
docker container rm -f my-flask-app-container
echo ""
docker run \
    -p 5500:5500 \
    -d \
    --name my-flask-app-container \
    my-flask-app-image:${VERSION}
