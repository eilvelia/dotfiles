#!/usr/bin/env bash

echo "Upgrading Homebrew packages..."

brew update
brew upgrade

echo "Installing Homebrew packages..."

brew install less # Upgrade less

brew install bash
brew install tree
brew install wget
brew install htop
brew install pwgen
brew install jq
brew install gnupg
brew install pgpdump
brew install unrar
brew install gnu-sed
brew install gnu-tar
brew install gawk
brew install fortune
brew install fzf
brew install ripgrep # aka rg. 'grep' alternative
brew install ag # 'grep' alternative
brew install fd # 'find' alternative
brew install eza # 'ls' alternative
brew install sd # 'sed' alternative
brew install bat # 'cat' / 'less' alternative
brew install highlight
brew install procs # 'ps' alternative
brew install dust # 'du' alternative
brew install bingrep
brew install hyperfine
brew install bandwhich # 'iftop' alternative
brew install pv
brew install iperf3
brew install tokei
brew install miniserve
brew install xz
brew install tldr
brew install neovim
brew install micro
brew install kakoune
brew install emojify
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
brew install swi-prolog
brew install v8
brew install wren
brew install wren-cli

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

brew install bfg # remove large files or passwords from git history

brew install tesseract

brew install qemu

brew install graphviz

brew install asciinema

brew install weechat

brew install youtube-dl

brew install innoextract

brew install yqrashawn/goku/goku
brew install muesli/tap/duf

echo "Installing cask packages..."

brew tap homebrew/cask-fonts

brew install --cask font-menlo-for-powerline
brew install --cask font-dejavusansmono-nerd-font
brew install --cask font-fantasque-sans-mono
brew install --cask font-fira-code
brew install --cask font-firacode-nerd-font
brew install --cask font-firacode-nerd-font-mono
brew install --cask font-iosevka
brew install --cask font-iosevka-nerd-font
brew install --cask font-sourcecodepro-nerd-font
brew install --cask font-symbols-only-nerd-font

brew install --cask iterm2
brew install --cask kitty
brew install --cask emacs
brew install --cask qbittorrent
brew install --cask sublime-text # proprietary
brew install --cask visual-studio-code
brew install --cask tunnelblick
brew install --cask keka
brew install --cask vlc
brew install --cask iina
brew install --cask electrum
# brew install --cask fork # proprietary
brew install --cask gfxcardstatus
brew install --cask macs-fan-control # proprietary
# brew install --cask dropbox # proprietary
brew install --cask db-browser-for-sqlite
brew install --cask hex-fiend
brew install --cask shiba
ln -s /Applications/Shiba.app/Contents/MacOS/Shiba /usr/local/bin/shiba
brew install --cask xrg
brew install --cask anybar
brew install --cask signal
brew install --cask tor-browser
brew install --cask love
brew install --cask vimr
brew install --cask keepassxc
brew install --cask netnewswire
brew install --cask macfuse
# brew install --cask docker # proprietary; can take a long time to install

echo "Installing fuse filesystems..."

brew install encfs
brew install cryfs

echo "Executing 'brew cleanup'..."

# Remove outdated versions
brew cleanup
