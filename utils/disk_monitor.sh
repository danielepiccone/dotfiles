#!/bin/bash
DISK=sda1

monitor::get_stats () {
  cat /proc/diskstats | grep $DISK
}

monitor::alert () {
  STATS=$1
  xset led named "Scroll Lock"
  sleep 0.001
  xset -led named "Scroll Lock"
}

while true; do
  NEXT_STATS=$(monitor::get_stats)
  if [[ $STATS != $NEXT_STATS ]]; then
    STATS=$NEXT_STATS
    monitor::alert "$NEXT_STATS"
  fi
done
