#!/bin/sh

CONFIG_NAME="HomeVPN"
LOGO=""

connection_status() { STATUS=$(ifconfig | grep "$CONFIG_NAME"); }

while true; do
	connection_status

	if [ "$STATUS" != "" ]; then
		echo "%{F#61afef}$LOGO%{F-}"
	else
		echo "%{F#BF616A}$LOGO%{F-}"
	fi
	sleep 1800
done
