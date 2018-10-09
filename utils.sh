#!/usr/bin/env bash

function confirm {
  while true; do
    read -p "$1 (Y/n): " RESP
    if [[ $RESP == "y"* || $RESP == "Y"* || $RESP == "" ]]; then
      return 0
    elif [[ $RESP == "n"* || $RESP == "N"* ]]; then
      return 1
    fi
  done
}
