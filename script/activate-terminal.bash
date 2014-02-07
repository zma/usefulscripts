#!/bin/env bash

# Written by Eric Zhiqiang Ma (http://www.ericzma.com)
# Last update: Feb. 6, 2014

# Required tools: xdotool

termtype="Terminal"

# if gnome-terminal is not opened yet, open it
terms=`xdotool search --class "$termtype"`
if [ "$terms" == "" ]
then
    gnome-terminal --maximize
    exit 0
fi

curwin=$(xdotool getwindowfocus)

# check whether it is already activated
# deactivate (minimize) the terminal if it is currently activated
for i in $terms
do
    if [ "$i" == "$curwin" ]
    then
        xdotool windowminimize $curwin
        exit 0
    fi
done

# current focus window is not a terminal
# activate the terminal
# actually, activate all terminals
for i in $terms
do
    xdotool windowactivate $i
done

