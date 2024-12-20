#!/usr/bin/env bash

# -e is deliberately omitted
set -uo pipefail

swayidle -w \
  timeout 15 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

pid=$!

(
  swaylock -e -c 222222
  kill $pid
) &
