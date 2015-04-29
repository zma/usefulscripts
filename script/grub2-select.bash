#!/bin/bash

# Author: Eric Zhiqiang Ma (http://www.ericzma.com)
# How to use this script:
# http://www.systutorials.com/3826/setting-default-entry-in-grub2-and-grub/

# TODO: 
# fix bug in checking "Invalid selection"

if [ -d /sys/firmware/efi ]; then
    grubcfg="/etc/grub2-efi.cfg"
else
    grubcfg="/etc/grub2.cfg"
fi

grep "^menuentry" $grubcfg | cut -d "'" -f2 >/tmp/grub2-select.entries

items=`cat /tmp/grub2-select.entries`

linen=`cat /tmp/grub2-select.entries | wc -l`

j=0
while [ $j -lt $linen ]
do
    let "j=j+1"
    echo -n "$j  "
    echo "$items" | head -n $j | tail -n1
done

olddef=`grub2-editenv list`

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

selected=`echo "$items" | head -n $sel | tail -n1`

echo "Entry: $selected"

grub2-set-default "$selected"

# make a backup just in case
cp $grubcfg $grubcfg-grub2-select.bak

# regenerate the config file now
grub2-mkconfig -o $grubcfg

newdef=`grub2-editenv list`

echo "New default:"
echo $newdef

