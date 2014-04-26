#!/bin/bash

# Author: Eric Zhiqiang Ma (http://www.ericzma.com)
# TODO: 
# print msg that it only works for grub 1
# fix bug in checking "Invalid selection"

grep "^menuentry" /boot/grub2/grub.cfg | cut -d "'" -f2 >/tmp/grub2-select.entries

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
grub2-mkconfig -o /boot/grub2/grub.cfg

newdef=`grub2-editenv list`

echo "New default:"
echo $newdef

