#!/bin/bash

#
# Use a keyboard led to show disk activity
#

DISK=sda1
LED_NAME="Scroll Lock"

monitor::get_stats () {
  cat /proc/diskstats | grep $DISK
}

monitor::alert () {
  STATS=$1
  xset led named "$LED_NAME"
  sleep 0.001
  xset -led named "$LED_NAME"
}

while true; do
  NEXT_STATS=$(monitor::get_stats)
  if [[ $STATS != $NEXT_STATS ]]; then
    STATS=$NEXT_STATS
    monitor::alert "$NEXT_STATS"
  fi
done
