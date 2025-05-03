#!/usr/bin/env bash

set -euo pipefail

function confirm {
  local _yellow="\033[1;33m"
  local _reset="\033[0m"

  if [[ $DOTFILES_AUTOCONFIRM == 1 ]]; then
    echo -e "$_yellow$1 (Y/n):$_reset y"
    return 0
  fi

  while true; do
    echo -en "$_yellow$1 (Y/n):$_reset "
    read -r RESP
    if [[ $RESP == "y"* || $RESP == "Y"* || $RESP == "" ]]; then
      return 0
    elif [[ $RESP == "n"* || $RESP == "N"* ]]; then
      return 1
    fi
  done
}

function chk {
  command -v "$1" &> /dev/null
}
