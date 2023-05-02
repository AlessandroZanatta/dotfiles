#!/bin/bash

# Mute output
amixer set Master mute

# Close dashboard
eww close-all

# Hibernate
systemctl hibernate
