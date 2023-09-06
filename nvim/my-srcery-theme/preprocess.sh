#!/usr/bin/env sh

cd ~/dotfiles/nvim/

clang -P -E -x c my_srcery.cpp.vim > ../colors/my_srcery.vim
clang -P -E -x c my_srcery_lightline.cpp.vim > ../autoload/lightline/colorscheme/my_srcery.vim
