#!/usr/bin/env bash

echo "Upgrading Homebrew packages..."

brew update
brew upgrade

echo "Installing Homebrew packages..."

# Upgrade less
brew install less

brew install emojify

brew install tree
brew install wget
brew install jq
brew install pwgen
brew install gnupg
brew install pgpdump
brew install unrar
brew install cmake

brew install autoconf
brew install automake

# lua
brew install lua
brew install luajit

# python
brew install python
brew install python3

brew install swi-prolog

brew install v8

# bfg - Remove large files or passwords from Git history
brew install bfg

brew install htop

brew install bash-completion

brew install screenfetch
brew install neofetch

brew install nmap
brew install tcpreplay
brew install aircrack-ng
brew install upx

brew install tor

brew install diff-so-fancy

echo "Installing cask packages..."

brew cask install iterm2
brew cask install emacs
brew cask install qbittorrent
brew cask install sublime-text # proprietary
brew cask install visual-studio-code
brew cask install tunnelblick
brew cask install keka
brew cask install electrum
brew cask install fork # proprietary
brew cask install gfxcardstatus
brew cask install macs-fan-control # proprietary
brew cask install db-browser-for-sqlite
brew cask install wire

# Remove outdated versions
brew cleanup
