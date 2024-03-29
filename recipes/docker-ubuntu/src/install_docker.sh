#!/bin/bash 

# Create and join the docker group.
sudo addgroup --system docker
sudo adduser $USER docker

# install docker from snap
sudo snap install docker

# install docker-compose
if [ ! -f   /usr/local/bin/docker-compose ];then
    curl -L https://github.com/docker/compose/releases/download/1.26.2/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose; chmod +x /tmp/docker-compose; sudo cp /tmp/docker-compose /usr/local/bin/docker-compose
fi

# install docker compose CLI
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose && chmod +x ~/.docker/cli-plugins/docker-compose

exit 0
