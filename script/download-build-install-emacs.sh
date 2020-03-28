#!/bin/env bash

# Install emacs of version $1
# Author: Eric Ma (https://www.ericzma.com)

if [ $# -lt 1 ]; then
    echo "Usage: $0 version"
    exit 1
fi

ver=$1

wget http://ftp.gnu.org/gnu/emacs/emacs-$ver.tar.gz && \
tar xf emacs-$ver.tar.gz && \
cd emacs-$ver && \
./configure  --with-xpm=no --with-jpeg=no --with-gif=no --with-tiff=no && \
make && \
sudo make install
