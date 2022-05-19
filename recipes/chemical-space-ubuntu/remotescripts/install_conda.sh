#!/bin/bash -e

# Exit if installed
if test -d "$HOME/conda" ; then
    exit 0
fi

cd /tmp
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3* -b -f -p "$HOME/conda"
. "$HOME/conda/bin/activate"
conda init
rm -f ./Miniconda3*
