#!/bin/bash
#
# Install Hyperledger Fabric 2.0.0 on Ubuntu 18.04 Linux.
#
# Check how to use it at:
# https://www.systutorials.com/how-to-install-hyperledger-fabric-2-0-in-ubuntu-18-04/
#
# Authors: Eric Ma (https://www.ericzma.com)
#
# Usage:
#    ./install-hyperledger-fabric-2-ubuntu-18.04.sh
#

set -o errexit
# set -x
mydir=$(dirname $0)

echo ""
echo "Set up Go 1.13.9 ..."
if [[ -e "/usr/local/go-1.13" ]]; then
  echo "Warning: Folder/file /usr/local/go-1.13 exists. It seems you have go 1.13 installed. Skip installation."
else
  $mydir/install-go.sh 1.13.9
fi

bashrcupdated=1
grep -Pzl '\nexport GOPATH=\$HOME/go\nexport PATH=\$GOPATH/bin:\$PATH\n' ~/.bashrc && bashrcupdated=0 || bashrcupdated=1

if [[ "$bashrcupdated" == "1" ]]; then
  echo 'export GOPATH=$HOME/go' >> ~/.bashrc
  echo 'export PATH=$GOPATH/bin:$PATH' >> ~/.bashrc
fi

source /etc/profile.d/Z99-go-1.13.sh
source ~/.bashrc

# set GOPATH explicitely
export GOPATH=$(eval echo $(go env | grep ^GOPATH= | cut -d'=' -f2))

echo ""
echo "Install packages ..."
sudo apt install git curl wget docker docker-compose nodejs npm
sudo npm install npm@5.6.0 -g
sudo usermod -aG docker $USER

echo ""
echo "Versions of software:"
docker --version
docker-compose --version
npm --version
go version

go get -u github.com/hyperledger/fabric-samples || rt=1
cd $GOPATH/src/github.com/hyperledger/fabric-samples
git checkout a026a4ffbfcf69f33a2a25cd71c5a776ca2fdda5

echo ""
echo "Install Hyperledger Fabric 2.0.0 binaries and coker images ..."
sg docker -c "curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.0 1.4.6 0.4.18 -s"
mkdir -p $GOPATH/bin/
cp -rv bin/* $GOPATH/bin/

echo ""
echo "Now start test-network ..."
cd $GOPATH/src/github.com/hyperledger/fabric-samples/test-network
sg docker -c "./network.sh up"

echo ""
echo ""
echo ""
echo "Congratulations! Your Hyperledger Fabric 2.0.0 test network is up."
echo ""
echo "Will create channel and register chaincode after a while..."
sleep 5

echo ""
echo "Creating channel mychannel ..."
sg docker -c "./network.sh createChannel -c mychannel"

echo ""
echo "Create a chaincode in go ..."
sg docker -c "./network.sh deployCC -l go"

echo ""
echo "**** Congratulations! ****"
echo "Your Hyperledger Fabric 2.0.0 test network with channel mychannel and chaincode fabcar is ready. Enjoy."
echo ""
echo ""
echo "To shutdown the network, first logout and then login again, then run:"
echo "cd $GOPATH/src/github.com/hyperledger/fabric-samples/test-network && ./network.sh down"
echo ""
