#!/usr/bin/env bash

_settings_dir=${VSCODE_SETTINGS_DIR:-"$HOME/Library/Application Support/Code/User"}

case $1 in
  export)
    cp "$_settings_dir/settings.json" settings.json
    cp "$_settings_dir/keybindings.json" keybindings.json
    code --list-extensions > extensions.txt
    ;;
  import)
    cp settings.json "$_settings_dir/settings.json"
    cp keybindings.json "$_settings_dir/keybindings.json"
    cat extensions.txt | xargs -L 1 code --install-extension
    ;;
  *)
    exit 1
    ;;
esac
