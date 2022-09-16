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

/bin/sh /mnt/base-us/extensions/onlinescreensaver/bin/scheduler.sh &
