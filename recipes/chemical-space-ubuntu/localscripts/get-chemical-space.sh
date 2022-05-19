#!/bin/bash 

# Fetch gaas

mkdir -p tmp
if [ ! -d tmp/chemical-space-web-service ]; then
    git clone git@github.com:NBISweden/chemical-space-web-service.git tmp/chemical-space-web-service
else 
    pushd tmp/chemical-space-web-service
    git pull --all --prune
    popd
fi
