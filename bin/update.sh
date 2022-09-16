#!/bin/sh
#
##############################################################################
#
# Fetch weather screensaver from a configurable URL.

# change to directory of this script
cd "$(dirname "$0")"

# load configuration
if [ -e "config.sh" ]; then
	source ./config.sh
else
	TMPFILE=/tmp/tmp.onlinescreensaver.png
fi

# load utils
if [ -e "utils.sh" ]; then
	source ./utils.sh
else
	echo "Could not find utils.sh in `pwd`"
	exit
fi

# do nothing if no URL is set
if [ -z $IMAGE_URI ]; then
	logger "No image URL has been set. Please edit config.sh."
	return
fi

# wait for network to be up
TIMER=${NETWORK_TIMEOUT}     # number of seconds to attempt a connection
CONNECTED=0                  # whether we are currently connected
while [ 0 -eq $CONNECTED ]; do
	# test whether we can ping outside
	/bin/ping -c 1 $TEST_DOMAIN > /dev/null && CONNECTED=1

	# if we can't, checkout timeout or sleep for 1s
	if [ 0 -eq $CONNECTED ]; then
		TIMER=$(($TIMER-1))
		if [ 0 -eq $TIMER ]; then
			logger "No internet connection after ${NETWORK_TIMEOUT} seconds, aborting."
			break
		else
			sleep 1
		fi
	fi
done

if [ 1 -eq $CONNECTED ]; then
	BATTERY_PERCENTAGE=$(getBatteryPercentage)
	URL="$IMAGE_URI&battery=$BATTERY_PERCENTAGE"

	logger "Fetching image from: $URL"
	if /mnt/us/extensions/onlinescreensaver/bin/fetch-file $URL $TMPFILE; then
		mv $TMPFILE $SCREENSAVERFILE
		logger "Screen saver image updated"

		# refresh screen
		lipc-get-prop com.lab126.powerd status | grep "Screen Saver" && (
			logger "Updating image on screen"
			eips -c
			eips -f -g $SCREENSAVERFILE
		)
	else
		logger "Error updating screensaver"

		DATE=$(date)
		eips 0 0 "Last update failed"
		eips 0 1 "$DATE"
	fi
fi
