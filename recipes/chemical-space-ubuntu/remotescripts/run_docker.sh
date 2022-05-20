#!/bin/bash

appdir=$HOME/software/chemical-space-web-service
pushd $appdir/frontend
npm install
npm audit fix
npm install --save-dev

docker-compose build
