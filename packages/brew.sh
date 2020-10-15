#!/usr/bin/env bash

echo "Upgrading Homebrew packages..."

brew update
brew upgrade

echo "Installing Homebrew packages..."

brew install less # Upgrade less

brew install tree
brew install wget
brew install htop
brew install pwgen
brew install jq
brew install gnupg
brew install pgpdump
brew install unrar
brew install gnu-sed
brew install fortune
brew install fzf
brew install ripgrep # aka rg. 'grep' alternative
brew install ag # 'grep' alternative
brew install fd # 'find' alternative
brew install exa # 'ls' alternative
brew install sd # 'sed' alternative
brew install bat # 'cat' / 'less' alternative
brew install procs # 'ps' alternative
brew install dust # 'du' alternative
brew install bingrep
brew install hyperfine
brew install bandwhich # 'iftop' alternative
brew install tokei
brew install miniserve
brew install xz
brew install tldr
brew install neovim
brew install micro
brew install emojify
brew install highlight
brew install ranger
brew install nnn
brew install diff-so-fancy
brew install bash-completion
brew install aspell

brew install screenfetch
brew install neofetch

brew install autoconf
brew install automake
brew install cmake
brew install ninja
brew install ccls
brew install bear

brew install perl
brew install ruby
brew install lua
brew install luajit
brew install python
brew install python@2
brew install swi-prolog
brew install v8

brew install redis
brew install postgresql
brew install mysql

brew install sshuttle
brew install httpie
brew install nmap
brew install tcpreplay
brew install speedtest-cli
brew install aircrack-ng
brew install upx
brew install hashcat

brew install tor
brew install ipfs

# bfg - Remove large files or passwords from Git history
brew install bfg

brew install tesseract

brew install qemu

brew install graphviz

brew install asciinema

brew install weechat

brew install youtube-dl

echo "Installing cask packages..."

brew tap homebrew/cask-fonts

brew cask install font-menlo-for-powerline

brew cask install font-dejavusansmono-nerd-font
brew cask install font-fantasque-sans-mono
brew cask install font-fira-code
brew cask install font-firacode-nerd-font
brew cask install font-firacode-nerd-font-mono
brew cask install font-iosevka
brew cask install font-iosevka-nerd-font
brew cask install font-sourcecodepro-nerd-font

brew cask install rq # "Record Query"
brew cask install iterm2
brew cask install emacs
brew cask install qbittorrent
brew cask install sublime-text # proprietary
brew cask install visual-studio-code
brew cask install tunnelblick
brew cask install keka
brew cask install vlc
brew cask install iina
brew cask install electrum
brew cask install fork # proprietary
brew cask install gfxcardstatus
brew cask install macs-fan-control # proprietary
brew cask install dropbox # proprietary
brew cask install db-browser-for-sqlite
brew cask install hex-fiend
brew cask install xrg
brew cask install wire
brew cask install signal
brew cask install tor-browser
brew cask install love
brew cask install vimr
brew cask install keepassxc
brew cask install netnewswire
brew cask install osxfuse
brew cask install docker

echo "Installing fuse filesystems..."

brew install encfs
brew install cryfs

echo "Executing 'brew cleanup'..."

# Remove outdated versions
brew cleanup
