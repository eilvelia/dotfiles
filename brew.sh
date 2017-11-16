#!/usr/bin/env bash

brew update
brew upgrade

brew install wget
brew install gnupg

# lua
brew install lua
brew install luajit

# bfg - Remove large files or passwords from Git history
brew install bfg

brew install screenfetch
brew install tree
brew install unrar

# Remove outdated versions
brew cleanup
