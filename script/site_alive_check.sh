#!/bin/bash

# You may use cron to trigger this regularly
# and add actions to be triggered for notifications.

localdir=/tmp/site-alive-check
testfileaddr=${localdir}/out
testurl=https://www.systutorials.com

if [[ "$1" != "" ]]; then
  testurl="$1"
fi

mkdir -p $localdir
rm -f ${testfileaddr}

wget --tries=3 --timeout=10 "${testurl}" -O ${testfileaddr}

# you may send email too using `mailx`
# e.g. https://www.systutorials.com/sending-email-from-mailx-command-in-linux-using-gmails-smtp/
#      https://www.systutorials.com/sending-email-using-mailx-in-linux-through-internal-smtp/

if [[ -f ${testfileaddr} ]]; then
  size=$(wc -c ${testfileaddr} | cut -d' ' -f1)
  if [[ "$size" != "0" ]]; then
    echo "[`date`] ${testurl} => ok"
    exit 0
  fi
fi

echo "[`date`] ${testurl} => failed"
exit 1
