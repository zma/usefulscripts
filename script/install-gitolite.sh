#!/bin/bash

# Install gitolite in one command
# For how to use it, please check
# https://www.systutorials.com/how-to-set-up-gitolite-git-server-a-ten-minute-tutorial/

if [ $# -lt 1 ]; then
    echo "Usage: $0 admin_pub_key"
    exit 1
fi

ADMIN_KEY=$1

cd ~
mkdir bin
echo "export PATH=$HOME/bin/:$PATH" >> .bashrc

git clone https://github.com/sitaramc/gitolite
gitolite/install -to $(realpath $HOME/bin/)
bin/gitolite setup -pk $ADMIN_KEY
