#!/bin/bash

CONF_FILE="$HOME/dotfiles/config/redshift/redshift.conf"
LOCKING_CONF_FILE="$HOME/dotfiles/config/redshift/redshift-locker.conf"
NORMAL_CONF_FILE="$HOME/dotfiles/config/redshift/redshift-normal.conf"

# Dirty trick to show the screen dimming: use redshift with decreased brightness
# by symlinking a lower brightness conf file into the conf file and restart redshift via systemctl
xidlehook \
	--not-when-fullscreen \
	--not-when-audio \
	--timer 110 \
	"ln -sf $LOCKING_CONF_FILE $CONF_FILE; systemctl --user restart redshift" \
	"ln -sf $NORMAL_CONF_FILE $CONF_FILE; systemctl --user restart redshift" \
	--timer 10 \
	"ln -sf $NORMAL_CONF_FILE $CONF_FILE; systemctl --user restart redshift; /usr/local/bin/lock" \
	""
