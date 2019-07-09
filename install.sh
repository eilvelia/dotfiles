#!/usr/bin/env bash

BAKDIR=~/.dotfiles.bak

echo "Home: $(echo ~)"

source ./utils.sh

if confirm "Link dotfiles?"; then
  mkdir -p ~/.emacs.d

  if confirm "Backup old dotfiles?"; then
    echo "Backup directory: $BAKDIR"
    rm -rf $BAKDIR
    mkdir -p "$BAKDIR"
    mv ~/.bash_profile "$BAKDIR/bash_profile"
    mv ~/.inputrc "$BAKDIR/inputrc"
    mv ~/.gitconfig "$BAKDIR/gitconfig"
    mv ~/.radare2rc "$BAKDIR/radare2rc"
    mv ~/.emacs.d/init.el "$BAKDIR/init.el"
    mv ~/.vimrc "$BAKDIR/vimrc"
    [ "$(ls -A $BAKDIR)" ] || rm -r $BAKDIR
  fi

  ln -s ~/dotfiles/bash_profile ~/.bash_profile
  ln -s ~/dotfiles/inputrc ~/.inputrc
  ln -s ~/dotfiles/gitconfig ~/.gitconfig
  ln -s ~/dotfiles/radare2rc ~/.radare2rc
  ln -s ~/dotfiles/emacs/init.el ~/.emacs.d/init.el
  ln -s ~/dotfiles/vimrc ~/.vimrc
fi

mkdir -p ~/.local

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "macOS detected."
  source ./macos.sh
fi

if confirm "Install Node.js?"; then
  ./node.sh
fi
