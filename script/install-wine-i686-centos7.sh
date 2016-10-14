#!/bin/bash

# Author: Eric Zhiqiang Ma (zma@ericzma.com)

set -o errexit

# Install

ver=1.8.5

echo "Uninstall old wine64 if you have installed it..."

yum erase wine wine-*

echo "Install wine building tools..."

yum groupinstall 'Development Tools'
yum install libjpeg-turbo-devel libtiff-devel
yum install libgcc.i686 libX11-devel.i686 freetype-devel.i686

echo "Download and unpack the wine source package..."

cd /usr/src
wget http://dl.winehq.org/wine/source/1.8/wine-${ver}.tar.bz2 -O wine-${ver}.tar.bz2
tar xjf wine-${ver}.tar.bz2

echo "Build wine..."
cd wine-${ver}/
mkdir -p wine32 wine64

echo "   build wine64..."
cd wine64
../configure --enable-win64
make -j 4

echo "   build wine32..."
cd ../wine32
../configure --with-wine64=../wine64
make -j 4

echo "Install wine..."
echo "   install wine32..."
make install

echo "   install wine64..."
cd ../wine64
make install

echo "Congratulation! All are done. Enjoy!"


# # Uninstall
# cd /usr/src/wine-${ver}/wine32
# make uninstall
# cd /usr/src/wine-${ver}/wine64
# make uninstall

