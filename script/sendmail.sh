#!/bin/bash

# Interactively send emails using `mail`'s default way (`sendmail`).

# License: GPLv3

# Authors:
# NerdOfCode ( https://github.com/NerdOfCode )
# Eric Ma ( https://www.ericzma.com )

#for saving the mail temporarily
random=$RANDOM

#Mail related functionality
mail=$(which mail)
mail_status=$?
check_ser=$(which sendmail)
check_ser_status=$?
temp_d=/tmp/
mail_ext=.mail

# #Checking GUI related functions
# gui_check="$(startx >/dev/null 2>&1)"
# gui_status=$?

echo -e "THIS PROGRAM IS OF NO WARRANTY!!! I AM NOT RESPONSIBLE FOR ANY
MISUSES OF IT. THIS SCRIPT IS SOLELY FOR EDUCATIONAL PURPOSES \n \n"
sleep 5
clear

if [ $mail_status != 0 ]
then
	echo "I am very sorry... But I require the mailutils package to sendmail"
	echo "I suggest using apt or yum to install"
	exit 1
fi

if [ $check_ser_status != 0 ]
then
	echo "I am very sorry... But I require the Postfix service"
	echo "I suggest using apt or yum to install"
	exit 1
fi

# if [ $gui_status == 0 ]
# then
# 	echo "WARNING!!! Running on home Computer is highly not recommended due to the increased chance of being mislead as spam"
# 	sleep 2
# 	exit 1
# fi

read -p "Enter from address: " from
read -p "Enter receiving address: " receive
read -p "Enter subject: " subject
echo "Enter message in one second: "
sleep 2
#Open a file to edit the body of a message
nano $temp_d$random$mail_ext
body=$(cat $temp_d$random$mail_ext)

read -p "Ready to send? (yes): " send

if [ $send == "yes" ]
then
	echo $body | MAILRC=/dev/null mail -r $from -s "$subject" $receive
	exit 0
else
	echo "The body of your message was stored here: $temp_d$random$mail_ext"
	exit 0
fi
