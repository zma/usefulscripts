#!/bin/bash
#
# Install Go on Linux.
# Check https://www.systutorials.com/?p=253721
#
# Authors: Eric Ma (https://www.ericzma.com)
#
# Usage:
#    ./install-go.sh <version>
#

set -o errexit

if [[ "$1" == "" ]]; then
  version=1.13.9
else
  version=$1
fi

majorver=$(echo ${version} | cut -d'.' -f1,2)
pkgfile=go${version}.linux-amd64.tar.gz
wget https://dl.google.com/go/${pkgfile} -O ${pkgfile}

if [[ -e go ]]; then
  echo "ERROR: Folder/file go exists."
  exit 1
fi

if [[ -e /usr/local/go-${majorver} ]]; then
  echo "ERROR: Folder/file /usr/local/go-${majorver} exists."
  exit 1
fi

tar xf ${pkgfile}
sudo mv go /usr/local/go-${majorver}

echo "export GOROOT=/usr/local/go-${majorver}\n
export PATH=\$GOROOT/bin:\$PATH" | sudo tee /etc/profile.d/Z99-go-${majorver}.sh

echo "Installed Go ${majorver}. You can now logout and login again to verify."
