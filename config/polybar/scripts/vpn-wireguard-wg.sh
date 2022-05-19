#!/bin/sh

config_name="HomeVPN"
wireguard_logo=" "

connection_status() {
    vpn_status=$(ifconfig | grep "$config_name")
    if [[ ! -z "$vpn_status" ]]; then
        echo "1"
    else
        echo "2"
    fi
}


case "$1" in
--toggle)
    if [ "$(connection_status)" = "1" ]; then
       	myVPN off
    else
    	myVPN on 
    fi
    ;;
*)
    if [ "$(connection_status)" = "1" ]; then
        echo "$wireguard_logo $config_name"
    else
        echo "$wireguard_logo down"
    fi
    ;;
esac
