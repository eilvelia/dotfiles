#!/usr/bin/env bash

_dir=~/dotfiles/plists

function _import_plist {
  defaults import "$1" - < "$_dir/$1.plist"
}

function _export_plist {
  defaults export "$1" - > "$_dir/$1.plist"
}

_plists=(
  com.googlecode.iterm2
  com.qvacua.VimR
  com.qvacua.VimR.menuitems
)

case $1 in
  import)
    for plist in "${_plists[@]}"; do
      echo "Importing $plist"
      _import_plist "$plist"
    done
    ;;
  export)
    for plist in "${_plists[@]}"; do
      echo "Exporting $plist"
      _export_plist "$plist"
    done
    ;;
  *)
    exit 1
    ;;
esac
