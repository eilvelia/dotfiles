#!/usr/bin/env bash

dotfiles=~/dotfiles

echo "Home: $(echo ~)"

cd $dotfiles

source ./install/utils.sh

if confirm "Link dotfiles?"; then
  mkdir -p ~/.config

  # ln -s $dotfiles/radare2rc ~/.radare2rc
  # mkdir -p ~/.emacs.d
  # ln -s $dotfiles/emacs/init.el ~/.emacs.d/init.el
  ln -s $dotfiles/inputrc ~/.inputrc
  ln -s $dotfiles/vimrc ~/.vimrc
  ln -s $dotfiles/git ~/.config/git
  ln -s $dotfiles/nvim ~/.config/nvim
  ln -s $dotfiles/fish ~/.config/fish
  ln -s $dotfiles/kitty ~/.config/kitty
  ln -s $dotfiles/ranger ~/.config/ranger
  mkdir -p ~/.config/direnv
  ln -s $dotfiles/direnv/direnvcrc ~/.config/direnv/direnvrc
fi

mkdir -p ~/.local

# Lots of outdated stuff here

if [[ "$OSTYPE" == "darwin"* ]] && confirm "Run macos.sh?"; then
  ./install/macos.sh
fi

# if chk npm && confirm "Install npm packages?"; then
#   ./packages/npm.sh
# fi
#
# if chk opam && confirm "Install opam packages?"; then
#   ./packages/opam.sh
# fi
#
# if chk pip3 && confirm "Install pip packages?"; then
#   ./packages/python.sh
# fi
