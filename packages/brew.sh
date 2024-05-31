#!/usr/bin/env bash

echo "Upgrading Homebrew packages..."

brew update
brew upgrade

echo "Installing Homebrew packages..."

brew install bash
brew install wget
brew install gnupg
brew install gnu-sed
# brew install gnu-tar
brew install gawk
brew install coreutils
brew install pkg-config
brew install tor
brew install openjdk
brew install rar
brew install zstd
brew install iperf3
brew install rsync
brew install rsnapshot
# brew install bfg

# brew install ninja
# brew install cmake
# brew install autoconf
# brew install automake
# brew install ccls
# brew install bear

# Many of the cli apps are installed via nix

# brew install tree
# brew install htop
# brew install pwgen
# brew install jq
# brew install pgpdump
# brew install fortune
# brew install fzf
# brew install ripgrep # aka rg. 'grep' alternative
# brew install fd # 'find' alternative
# brew install eza # 'ls' alternative
# brew install sd # 'sed' alternative
# brew install bat # 'cat' / 'less' alternative
# brew install highlight
# brew install procs # 'ps' alternative
# brew install dust # 'du' alternative
# brew install bingrep
# brew install hyperfine
# brew install bandwhich # 'iftop' alternative
# brew install pv
# brew install tokei
# brew install miniserve
# brew install xz
# brew install tldr
# brew install neovim
# brew install micro
# brew install kakoune
# brew install emojify
# brew install ranger
# brew install nnn
# brew install diff-so-fancy
# brew install bash-completion
# brew install aspell
# brew install neofetch
# brew install hyfetch

# brew install perl
# brew install ruby
# brew install lua
# brew install luajit
# brew install python
# brew install swi-prolog
# brew install v8
# brew install wren
# brew install wren-cli

# brew install redis
# brew install postgresql
# brew install mysql

# brew install sshuttle
# brew install httpie
# brew install nmap
# brew install tcpreplay
# brew install speedtest-cli
# brew install aircrack-ng
# brew install upx
# brew install hashcat

# brew install tesseract
# brew install qemu
# brew install graphviz
# brew install asciinema
# brew install weechat
# brew install youtube-dl
# brew install innoextract

# brew install yqrashawn/goku/goku
# brew install muesli/tap/duf

echo "Installing cask packages..."

brew install --cask kitty
brew install --cask qbittorrent
brew install --cask visual-studio-code
brew install --cask sublime-text # proprietary
brew install --cask sublime-merge # proprietary
brew install --cask iina
brew install --cask keka
brew install --cask hex-fiend
brew install --cask telegram-desktop
brew install --cask signal
brew install --cask keybase
brew install --cask tor-browser
brew install --cask electrum
brew install --cask tunnelblick
brew install --cask insomnia
brew install --cask db-browser-for-sqlite
brew install --cask shiba
ln -s /Applications/Shiba.app/Contents/MacOS/Shiba /usr/local/bin/shiba
brew install --cask gfxcardstatus
brew install --cask macs-fan-control # proprietary
brew install --cask karabiner-elements
brew install --cask steam
brew install --cask virtualbox

brew install --cask macfuse

# brew install --cask iterm2
# brew install --cask emacs
# brew install --cask vlc
# brew install --cask fork # proprietary
# brew install --cask dropbox # proprietary
# brew install --cask xrg
# brew install --cask anybar
# brew install --cask love
# brew install --cask netnewswire
# brew install --cask docker # proprietary; can take a long time to install

echo "Installing fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
brew install --cask font-symbols-only-nerd-font
brew install --cask font-menlo-for-powerline
# brew install --cask font-dejavusansmono-nerd-font
# brew install --cask font-fantasque-sans-mono

# echo "Installing fuse filesystems..."
# brew install encfs
# brew install cryfs

echo "Executing 'brew cleanup'..."

# Remove outdated versions
brew cleanup
