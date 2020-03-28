#!/bin/bash

# Check alive servers by ping
# Author: Eric Ma https://www.ericzma.com

if [ $# -lt 1 ]
then
    printf "usage: $0 file\n"
    printf "Each host in one line in the file\n"
    exit 0
fi

infile=$1

while read line
do
    res=`ping -W1 -c1 $line | grep received | awk '{print $4}'`
    if [ "$res" == "1" ]
    then
        echo $line
    fi
done < $infile

