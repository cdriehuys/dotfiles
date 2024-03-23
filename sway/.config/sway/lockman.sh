#!/bin/sh

swayidle \
    timeout 10 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &
# Locks the screen immediately
swaylock -c 333333
# Kills last background task so idle timer doesn't keep running
kill %%
