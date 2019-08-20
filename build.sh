#!/bin/sh -e

REPO=${1:-docker.io/thekad/irc-slack}

echo "Building ${REPO}:build"

docker build -t ${REPO}:build . -f Dockerfile.build

echo "Extracting binary from build image"
docker create --name extract ${REPO}:build
docker cp extract:/go/bin/irc-slack ./irc-slack
docker rm -f extract

echo "Building ${REPO}:latest"

docker build --no-cache -t ${REPO}:latest .
