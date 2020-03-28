#!/bin/bash

# Author: Eric Ma (https://www.ericzma.com)
# How to use this script:
# https://www.systutorials.com/setting-default-entry-in-grub2-and-grub/

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

# olddef=`grub2-editenv list`
#
# echo "Old default:"
# echo $olddef

echo -n "Your select: "
read sel

if [[ "$sel" == "" ]]; then
    echo "Invalid selection"
    exit 0
fi

if [ $sel -lt "0" ] && [ $sel -ge $linen ]; then
    echo "Invalid selection"
    exit 0
fi

# echo "You select $sel"

selected=`echo "$items" | head -n $sel | tail -n1`

echo "Entry selected: $selected"

# set-default and change default entry files
# to make double insurance. Seems not every versions of grub2 respect
# both.
grub2-set-default "$selected"

# change the default entry in /etc/default/grub
# save a copy first
cp /etc/default/grub /etc/default/grub-grub2-select.bak

# change the default entry now
sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=\"$selected\"/g" /etc/default/grub

# make a backup just in case
cp $grubcfg $grubcfg-grub2-select.bak

# regenerate the config file now
# grub2-mkconfig of some versions do not respect the symbolic links
# so generate to a tmporary file and then use cp to update the grubcfg file
tmpfile=/tmp/$(basename $0)-grub2.cfg
grub2-mkconfig -o $tmpfile && cp $tmpfile $grubcfg

# newdef=`grub2-editenv list`

# echo "New default:"
# echo $newdef

