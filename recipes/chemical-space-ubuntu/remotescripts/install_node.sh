#!/bin/bash -e


cd /tmp
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
grep -v return ~/.bashrc > ~/.sourcefile
. ~/.sourcefile
nvm install node 
exit 0
