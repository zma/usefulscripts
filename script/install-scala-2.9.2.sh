#!/bin/bash

# Install scala 2.9.2
# Author: Zhiqiang Ma http://www.zhiqiangma.com

echo "You need to run this as root or by sudo. 
Enter to continue. Ctrl-C to abort."

read input

wget http://www.scala-lang.org/downloads/distrib/files/scala-2.9.2.tgz
tar xf scala-2.9.2.tgz

mv scala-2.9.2 /opt/
echo "export PATH=/opt/scala-2.9.2/bin/:$PATH" > /etc/profile.d/scala-2.9.2.sh

rm -f scala-2.9.2.tgz

