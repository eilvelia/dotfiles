#!/usr/bin/env bash

BAKDIR=~/.dotfiles.bak

# backup old dotfiles
rm -rf $BAKDIR
mkdir "$BAKDIR"
mv ~/.bash_profile "$BAKDIR/bash_profile"
[ "$(ls -A $BAKDIR)" ] || rm -r $BAKDIR
# ---

ln -s ~/dotfiles/bash_profile ~/.bash_profile

defaults import com.googlecode.iterm2 - < ./com.googlecode.iterm2.plist
