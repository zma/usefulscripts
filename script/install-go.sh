#!/bin/bash
#
# Install Go on Linux.
# Check how to use it at:
# https://www.systutorials.com/how-to-install-go-1-13-x-on-ubuntu-18-04/
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

if [[ -e /usr/local/go-${majorver} ]]; then
  echo "ERROR: Folder/file /usr/local/go-${majorver} exists."
  exit 1
fi

tmpdir=tmp-go-${version}-$(date +%s)
mkdir -p ${tmpdir}
cd ${tmpdir}

wget https://dl.google.com/go/${pkgfile} -O ${pkgfile}

tar xf ${pkgfile}
sudo mv go /usr/local/go-${majorver}

rm -f ${pkgfile}
cd ..
rmdir ${tmpdir}

echo -e "export GOROOT=/usr/local/go-${majorver}\n
export PATH=\$GOROOT/bin:\$PATH" | sudo tee /etc/profile.d/Z99-go-${majorver}.sh

echo "Installed Go ${majorver}. You can now logout and login again to verify."
