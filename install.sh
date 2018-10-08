#!/usr/bin/env bash

BAKDIR=~/.dotfiles.bak

# backup old dotfiles
rm -rf $BAKDIR
mkdir "$BAKDIR"
mv ~/.bash_profile "$BAKDIR/bash_profile"
mv ~/.gitconfig "$BAKDIR/gitconfig"
[ "$(ls -A $BAKDIR)" ] || rm -r $BAKDIR
# ---

ln -s ~/dotfiles/bash_profile ~/.bash_profile
ln -s ~/dotfiles/gitconfig ~/.gitconfig

mkdir -p ~/.local

if [[ "$OSTYPE" == "darwin"* ]]; then
  source ./macos.sh
fi
