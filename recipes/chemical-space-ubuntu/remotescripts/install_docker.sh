#!/bin/bash 

# Create and join the docker group.
sudo addgroup --system docker
sudo adduser "$(id -u -n)" docker

# install docker from snap
sudo snap install docker

sudo snap start docker

# install docker compose CLI
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose && chmod +x ~/.docker/cli-plugins/docker-compose


exit 0
