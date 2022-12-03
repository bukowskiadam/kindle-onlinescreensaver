#!/bin/sh
#
##############################################################################
#
# Fetch weather screensaver from a configurable URL at configurable intervals.
#
# Features:
#   - updates even when device is suspended
#   - refreshes screensaver image if active
#   - turns WiFi on and back off if necessary
#   - tries to use as little CPU as possible
#
##############################################################################

# change to directory of this script
cd "$(dirname "$0")"

# load configuration
if [ -e "config.sh" ]; then
	source ./config.sh
fi

# load utils
if [ -e "utils.sh" ]; then
	source ./utils.sh
else
	echo "Could not find utils.sh in `pwd`"
	exit
fi


# forever and ever, try to update the screensaver
while [ 1 -eq 1 ]; do 
	WAIT_TIME=$(sh ./update.sh)
	
	if [ -z "$WAIT_TIME" ]; then
		WAIT_TIME=3600
	fi
	
	# wait for the next trigger time
	wait_for $WAIT_TIME
done
