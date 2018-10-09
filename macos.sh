#!/usr/bin/env bash

source ./utils.sh

defaults import com.googlecode.iterm2 - < ./com.googlecode.iterm2.plist

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
