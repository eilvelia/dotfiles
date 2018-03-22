#!/usr/bin/env bash

defaults import com.googlecode.iterm2 - < ./com.googlecode.iterm2.plist

if ! which brew &> /dev/null; then
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if which brew &> /dev/null; then
  source ./brew.sh
fi
