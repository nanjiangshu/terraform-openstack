#!/bin/bash

appdir=$HOME/nbis/chemical-space-web-service
pushd $appdir/frontend
. ~/.sourcefile
npm install
npm audit fix
npm install --save-dev

docker-compose build
docker-compose up -d
