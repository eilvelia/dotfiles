#!/usr/bin/env bash

# -e is deliberately omitted
set -uo pipefail

if command -v makoctl > /dev/null 2>&1; then
  makoctl mode -a away
fi

swayidle -w \
  timeout 15 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

pid=$!

(
  swaylock -e -c 222222
  kill $pid
  if command -v makoctl > /dev/null 2>&1; then
    makoctl mode -r away
  fi
) &
