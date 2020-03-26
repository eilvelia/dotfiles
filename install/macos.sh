#!/usr/bin/env bash

source ./utils.sh

if confirm "Set the options?"; then
  ./macos-options.sh
fi

if confirm "Import the iTerm2 settings?"; then
  defaults import com.googlecode.iterm2 - < ./com.googlecode.iterm2.plist
fi

if confirm "Import the text replacement settings?"; then
  ./convert-text-replacements.js
  ./manage-text-replacements.sh import
fi

if ! which brew &> /dev/null && confirm "Download and install Homebrew?"; then
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if which brew &> /dev/null; then
  if confirm "Install Homebrew packages?"; then
    source ./packages/brew.sh
  fi
else
  echo "Homebrew not found."
fi
