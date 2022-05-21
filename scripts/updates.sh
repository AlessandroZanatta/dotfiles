#!/usr/bin/env bash

NOTIFY_ICON=system-software-update
OUTFILE=/tmp/checkupdates

get_total_updates() { 
    UPDATES_BASE=$(checkupdates 2>/dev/null | wc -l)
    UPDATES_AUR=$(yay -Qum 2>/dev/null | wc -l)

    UPDATES=$((UPDATES_BASE + UPDATES_AUR))
}

while true; do
    get_total_updates

    # notify user of updates
    if hash notify-send &>/dev/null; then
        if (( UPDATES > 100 )); then
            notify-send -u critical -i $NOTIFY_ICON \
                "You really need to update!!" "$UPDATES New packages"
        elif (( UPDATES > 50 )); then
            notify-send -u normal -i $NOTIFY_ICON \
                "You should update soon" "$UPDATES New packages"
        elif (( UPDATES > 10 )); then
            notify-send -u low -i $NOTIFY_ICON \
                "$UPDATES New packages"
        fi
    fi

    # Every 30 minutes check if there are more updates
    echo "$UPDATES" >> $OUTFILE
    sleep 1800
done
