#!/bin/bash

# Author: Eric Ma (https://www.ericzma.com)
# TODO: 
# print msg that it only works for grub 1
# fix bug in checking "Invalid selection"

linen=`cat /boot/grub/grub.conf | grep ^title | wc -l`

j=0
while [ $j -lt $linen ]
do
    echo -n "$j  "
    let "j=j+1"
    cat /boot/grub/grub.conf | grep ^title | head -n $j | tail -n1 | cut -d' ' -f2-
done

olddef=`cat /boot/grub/grub.conf | grep default`

echo "Old default:"
echo $olddef

echo "Your select: "
read sel

if [ $sel -lt "0" ] && [ $sel -ge $linen ]
then
    echo "Invalid selection"
    exit 0
fi

echo "You select $sel"

echo "sed -i \"s/$olddef/default=$sel/g\" /boot/grub/grub.conf" > /tmp/gst.sh

sh /tmp/gst.sh

newdef=`cat /boot/grub/grub.conf | grep default`

echo "New default:"
echo $newdef

