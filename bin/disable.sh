#!/bin/sh

cd "$(dirname "$0")"

# load utils
if [ -e "utils.sh" ]; then
	source ./utils.sh
else
	echo "Could not find utils.sh in `pwd`"
	exit
fi

logger "Enabling scheduler"

SCHEDULER_PID=`ps xa | grep "/bin/sh /mnt/base-us/extensions/onlinescreensaver/bin/scheduler.sh" | grep -v "grep" | awk '{ print $1 }'`

if [ -n "$SCHEDULER_PID" ]; then
	kill $SCHEDULER_PID || true
fi
