#!/usr/bin/env bash

_bakdir=~/.dotfiles.bak

echo "Home: $(echo ~)"

cd ~/dotfiles/

source ./install/utils.sh

if confirm "Link dotfiles?"; then
  mkdir -p ~/.emacs.d
  mkdir -p ~/.config

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
    mv ~/.config/kitty "$_bakdir/kitty"
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
  ln -s ~/dotfiles/kitty ~/.config/kitty
fi

mkdir -p ~/.local

if [[ "$OSTYPE" == "darwin"* ]] && confirm "macOS detected. Run macos.sh?"; then
  ./install/macos.sh
fi

if ! grep fish /etc/shells &> /dev/null && confirm "Setup fish as the default shell?"; then
  ./install/setup-fish.sh
fi

if chk fish && ! fish -c "type -q omf" && confirm "Download and install oh my fish?"; then
  ./install/omf.fish
fi

if (! chk n || ! chk node || ! chk npm) && confirm "Install Node.js?"; then
  ./install/node.sh
fi

if chk npm && confirm "Install the npm packages?"; then
  ./packages/npm.sh
fi

if chk opam && confirm "Install the opam packages?"; then
  ./packages/opam.sh
fi

if chk pip3 && confirm "Install the pip packages?"; then
  ./packages/python.sh
fi
