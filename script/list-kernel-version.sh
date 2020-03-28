#!/bin/bash

# list kernel version on all hosts whose IPs are in a file
# Author: Eric Ma https://www.ericzma.com

if [ $# -lt 1 ]
then
    printf "usage: $0 file\n"
    printf "Each host in one line in the file\n"
    exit 0
fi

infile=$1

for line in `cat $infile`;
do
    echo -n "$line "; 
    ssh $line 'uname -r';
done

