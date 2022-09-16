##############################################################################
# Logs a message to a log file (or to console if argument is /dev/stdout)

logger () {
	MSG=$1
	
	# do nothing if logging is not enabled
	if [ "x1" != "x$LOGGING" ]; then
		return
	fi

	# if no logfile is specified, set a default
	if [ -z $LOGFILE ]; then
		$LOGFILE=stdout
	fi

	echo `date`: $MSG >> $LOGFILE
}


##############################################################################
# Retrieves the current time in seconds

currentTime () {
	date +%s
}


# runs when in the readyToSuspend state;
# sets the rtc to wake up
# arguments: $1 - amount of seconds to wake up in
set_rtc_wakeup()
{
	lipc-set-prop -i com.lab126.powerd rtcWakeup $1 2>&1
	logger "rtcWakeup has been set to $1"
}

##############################################################################
# sets an RTC alarm
# arguments: $1 - time in seconds from now

wait_for () {
	ENDWAIT=$(( $(currentTime) + $1 ))
	REMAININGWAITTIME=$(( $ENDWAIT - $(currentTime) ))
	logger "Starting to wait for timeout to expire: $1"

	# wait for timeout to expire
	while [ $REMAININGWAITTIME -gt 0 ]; do
		EVENT=$(lipc-wait-event -s $1 com.lab126.powerd readyToSuspend,wakeupFromSuspend,resuming)
		REMAININGWAITTIME=$(( $ENDWAIT - $(currentTime) ))
		logger "Received event: $EVENT"

		case "$EVENT" in
			readyToSuspend*)
				set_rtc_wakeup $REMAININGWAITTIME
			;;
			wakeupFromSuspend*|resuming*)
				logger "Finishing the wait"
				break
			;;
			*)
				logger "Ignored event: $EVENT"
			;;
		esac
	done

	logger "Wait finished"
}

##############################################################################
# Retrieves the current time in seconds

getBatteryPercentage () {
	BATTERY=$(lipc-get-prop com.lab126.powerd status | grep "Battery Level" | cut -d' ' -f3 | sed 's/%//g')
	echo $BATTERY
}
