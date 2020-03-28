#!/bin/bash

# Install scala of version $1
# Author: Eric Ma (https://www.ericzma.com)

if [ $# < 2 ]
then
    echo "Usage: $0 version"
    exit 1
fi

ver=$1

echo "You are to install scala $ver to /opt/"
echo ""
echo "You need to run this as root or by sudo.
Enter to continue. Ctrl-C to abort."

read input

wget http://www.scala-lang.org/files/archive/scala-$ver.tgz
tar xf scala-$ver.tgz -C /opt/

echo "export PATH=/opt/scala-$ver/bin/:\$PATH" > /etc/profile.d/scala.sh

rm -f scala-$ver.tgz

echo "Scala $ver is installed."
echo "Please login again and try to run \`scala\` and test it"
echo "Enjoy!"
