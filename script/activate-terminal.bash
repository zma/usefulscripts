#!/bin/env bash

# Written by Eric Zhiqiang Ma (http://www.ZhiqiangMa.com)
# Last update: Feb. 6, 2014

# Required tools: xdotool

termname="Terminal"

# if gnome-terminal is not opened yet, open it
exist=`xdotool search --name --class --classname "$termname"`
if [ "$exist" == "" ]
then
    gnome-terminal --maximize
    exit 0
fi

# check whether it is already activated
actwin=`xdotool getwindowname $(xdotool getwindowfocus)`

if [ "$actwin" == "$termname" ]
then
    # deactivate (minimize) the terminal if it is currently activated
    xdotool windowminimize $(xdotool getactivewindow)
else
    # activate the terminal
    # actually, activate all windows named $termname
    for i in `xdotool search --name --class --classname "$termname"`
    do
        xdotool windowactivate $i
    done
fi

