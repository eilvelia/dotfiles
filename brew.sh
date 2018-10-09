#!/usr/bin/env bash

echo "Upgrading Homebrew packages..."

brew update
brew upgrade

echo "Installing Homebrew packages..."

# Upgrade less
brew install less

brew install emojify

brew install tree
brew install jq
brew install pwgen
brew install unrar

brew install wget
brew install gnupg

# lua
brew install lua
brew install luajit

brew install python

# bfg - Remove large files or passwords from Git history
brew install bfg

brew install htop

brew install bash-completion

brew install screenfetch
brew install neofetch

# Remove outdated versions
brew cleanup
