#!/usr/bin/env bash

if command -v pip2 &> /dev/null; then
  pip2 install --user neovim
else
  echo "Warning: pip2 is not installed."
fi

pip3 install --user neovim
pip3 install --user neovim-remote

pip3 install scan-build
