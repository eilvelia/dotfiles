#!/usr/bin/env bash

_bakdir=~/.dotfiles.bak

echo "Home: $(echo ~)"

cd ~/dotfiles/

source ./utils.sh

if confirm "Link dotfiles?"; then
  mkdir -p ~/.emacs.d/
  mkdir -p ~/.config/

  if confirm "Backup old dotfiles?"; then
    echo "Backup directory: $_bakdir"
    rm -rf $_bakdir
    mkdir -p "$_bakdir"
    mv ~/.bash_profile "$_bakdir/bash_profile"
    mv ~/.inputrc "$_bakdir/inputrc"
    mv ~/.gitconfig "$_bakdir/gitconfig"
    mv ~/.radare2rc "$_bakdir/radare2rc"
    mv ~/.emacs.d/init.el "$_bakdir/init.el"
    mv ~/.vimrc "$_bakdir/vimrc"
    mv ~/.config/nvim "$_bakdir/nvim"
    mv ~/.config/fish "$_bakdir/fish"
    mv ~/.config/omf "$_bakdir/omf"
    mv ~/.config/ranger "$_bakdir/ranger"
    [ "$(ls -A $_bakdir)" ] || rm -r $_bakdir
  fi

  ln -s ~/dotfiles/bash_profile ~/.bash_profile
  ln -s ~/dotfiles/inputrc ~/.inputrc
  ln -s ~/dotfiles/gitconfig ~/.gitconfig
  ln -s ~/dotfiles/radare2rc ~/.radare2rc
  ln -s ~/dotfiles/emacs/init.el ~/.emacs.d/init.el
  ln -s ~/dotfiles/vimrc ~/.vimrc
  ln -s ~/dotfiles/nvim ~/.config/nvim
  ln -s ~/dotfiles/fish ~/.config/fish
  ln -s ~/dotfiles/omf ~/.config/omf
  ln -s ~/dotfiles/ranger ~/.config/ranger
fi

mkdir -p ~/.local

if [[ "$OSTYPE" == "darwin"* ]] && confirm "macOS detected. Run macos.sh?"; then
  source ./install/macos.sh
fi

if confirm "Install Node.js?"; then
  ./install/node.sh
fi

if confirm "Setup fish as the default shell?"; then
  ./install/setup-fish.sh
fi

if confirm "Download and install oh my fish?"; then
  ./install/omf.fish
fi
