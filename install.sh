#!/usr/bin/env bash

cd ~ || exit 1
echo "Home: $(pwd)"

BAKDIR=~/.dotfiles.bak

# backup old dotfiles
echo "Backup directory: $BAKDIR"
rm -rf $BAKDIR
mkdir -p "$BAKDIR"
mv ~/.bash_profile "$BAKDIR/bash_profile"
mv ~/.gitconfig "$BAKDIR/gitconfig"
[ "$(ls -A $BAKDIR)" ] || rm -r $BAKDIR
# ---

ln -s ~/dotfiles/bash_profile ~/.bash_profile
ln -s ~/dotfiles/gitconfig ~/.gitconfig

mkdir -p ~/.local

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "macOS detected"
  source ./macos.sh
fi

source ./node.sh
