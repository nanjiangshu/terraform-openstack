#!/bin/bash

appdir=$HOME/software/chemical-space-web-service 
pushd $appdir
npm install
npm install --save-dev

docker-compose build
