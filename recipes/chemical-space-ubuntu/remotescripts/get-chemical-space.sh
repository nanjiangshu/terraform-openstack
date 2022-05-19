#!/bin/bash 

# Fetch chemical-space

mkdir -p $HOME/software
if [ ! -d $HOME/software/chemical-space-web-service ]; then
    git clone git@github.com:NBISweden/chemical-space-web-service.git $HOME/software/chemical-space-web-service
else 
    pushd $HOME/software/chemical-space-web-service
    git pull --all --prune
    popd
fi
