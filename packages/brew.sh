#!/usr/bin/env bash

echo "Upgrading Homebrew packages..."

brew update
brew upgrade

echo "Installing Homebrew packages..."

# Upgrade less
brew install less

brew install emojify

brew install autoconf
brew install automake

brew install tree
brew install wget
brew install jq
brew install pwgen
brew install gnupg
brew install unrar
brew install cmake

# lua
brew install lua
brew install luajit

# python
brew install python
brew install python3

# bfg - Remove large files or passwords from Git history
brew install bfg

brew install htop

brew install bash-completion

brew install screenfetch
brew install neofetch

brew install tcpreplay
brew install upx

brew install diff-so-fancy

# Remove outdated versions
brew cleanup
