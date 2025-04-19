#!/usr/bin/env bash
# Toggle do not disturb

set -euo pipefail

function print_result {
  echo "{\"text\":\"$1\",\"alt\":\"$1\",\"tooltip\":\"\",\"class\":\"$1\"}"
}

case "${1:-}" in
  toggle)
    if [[ $(makoctl mode -t 'do-not-disturb') == *"do-not-disturb"* ]]; then
      print_result dnd
    else
      print_result normal
    fi
    ;;
  get)
    if [[ $(makoctl mode) == *"do-not-disturb"* ]]; then
      print_result dnd
    else
      print_result normal
    fi
    ;;
  *)
    echo "Usage: $0 [toggle | get]"
    exit 1
    ;;
esac
