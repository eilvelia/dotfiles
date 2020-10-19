#!/usr/bin/env bash

source ./install/utils.sh

if confirm "Set the options?"; then
  ./macos-options.sh
fi

if confirm "Import the plists?"; then
  ./manage-plists.sh import
fi

if confirm "Import the text replacement settings?"; then
  ./convert-text-replacements.js
  ./manage-text-replacements.sh import
fi

if confirm "Install the startup script?"; then
  sed "s|\$HOME|$HOME|g" ./local.startupscript.plist \
    > ~/Library/LaunchAgents/local.startupscript.plist
fi

# if confirm "Copy the karabiner-elements config?"; then
#   mkdir -p ~/.config/karabiner/assets/complex_modifications
#   cp ./karabiner_rules/personal.json \
#     ~/.config/karabiner/assets/complex_modifications/personal.json
# fi

if ! chk brew &> /dev/null && confirm "Download and install Homebrew?"; then
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if chk brew &> /dev/null; then
  if confirm "Install Homebrew packages?"; then
    source ./packages/brew.sh
  fi
else
  echo "Homebrew not found."
fi

if confirm "Install the karabiner-elements config (goku is required)?"; then
  ./goku_update.sh
fi
