#!/usr/bin/env bash

source ./install/utils.sh

if confirm "Import the plists?"; then
  ./manage-plists.sh import
fi

if ! chk brew &> /dev/null && confirm "Download and install Homebrew?"; then
  echo "Installing Homebrew..."
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
