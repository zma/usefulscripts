#!/bin/bash

# Run a cmd on all servers from a file with each IP in a line
# Author: Eric Ma https://www.ericzma.com

if [ $# -lt 2 ]
then
    printf "usage: $0 file cmd\n"
    printf "Each host in one line in the file\n"
    exit 0
fi

infile=$1
shift
cmd=$1

echo "To invoke cmd: $cmd"

for line in `cat $infile`;
do
    echo "$line "; 
    ssh $line "$cmd";
done

