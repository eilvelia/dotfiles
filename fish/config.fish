if not status --is-interactive
  exit
end

set -l dotfiles ~/dotfiles

set fish_greeting

source $__fish_config_dir/colors.fish

# The default is Alt-e / Alt-v
bind \cx\ce edit_command_buffer

alias ls "ls -FA"

abbr -ag ez "eza --all -l --git"
abbr -ag eza-tree "eza --tree --git-ignore"

# gpg symmetric encrypt
alias gpgenc "gpg -c --s2k-mode 3 --s2k-digest-algo sha512 --s2k-count 65011712 --s2k-cipher-algo aes256"

# light nvim
alias lvi "nvim --cmd 'let g:min_mode = 1'"

# "private" mode
alias lvi-p "nvim --cmd 'let g:min_mode = 1' -i NONE --cmd 'set noswapfile'"

abbr -ag getdate "date \"+%Y_%m_%d\""

abbr -ag qfind "find . -name"

abbr -ag e "echo"

abbr -ag f "ls | grep -i"

abbr -ag totarbz2 "tar cjvf"
abbr -ag fromtarbz2 "tar xjvf"
abbr -ag totargz "tar czvf"
abbr -ag fromtargz "tar xzvf"

abbr -ag sha256sum "shasum -a 256"

abbr -ag gs "git status"

abbr -ag ra "ranger"

abbr -ag hi "highlight"

abbr -ag npmplease "rm -rf node_modules/ package-lock.json && npm install"
abbr -ag pnpmflat "pnpm install --shamefully-flatten"
abbr -ag npmr "npm run"

abbr -ag youtube-music "youtube-dl --extract-audio --audio-format vorbis"

abbr -ag nixi "nix profile install"

abbr -ag vimr "vimr --cur-env"

abbr -ag start-postgres "pg_ctl -D /usr/local/var/postgres start"
abbr -ag stop-postgres "pg_ctl -D /usr/local/var/postgres stop"

abbr -ag start-redis "redis-server /usr/local/etc/redis.conf"

set -x LANG en_US.UTF-8

set -x CLICOLOR 1

if test "$TERM" = "xterm-kitty"
  set -x LSCOLORS gxbxhxdxfxhxhxhxhxcxcx
  set -x LS_COLORS \
    "di=36:ln=31:so=37:pi=33:ex=35:bd=37:cd=37:su=37:sg=37:tw=32:ow=32"
  abbr -ag icat "kitten icat"
else
  set -x LSCOLORS gxBxhxDxfxhxhxhxhxcxcx
  set -x LS_COLORS \
    "di=36:ln=1;31:so=37:pi=1;33:ex=35:bd=37:cd=37:su=37:sg=37:tw=32:ow=32"
end

set -x VISUAL nvim
set -x EDITOR nvim

set -x GPG_TTY (tty)
set -x LESSCHARSET utf-8
set -x INPUTRC ~/.inputrc

set -xp PATH ~/.local/bin

set -xp PATH $dotfiles/global-scripts

if test -d ~/.cargo
  set -xp PATH ~/.cargo/bin
end

source ~/.opam/opam-init/init.fish > /dev/null 2>&1 || true
set -x OPAMNODEPEXTS 1

set -x HOMEBREW_NO_AUTO_UPDATE 1

if test "$LC_TERMINAL" = "iTerm2"
   and test -r $dotfiles/vendor/.iterm2_shell_integration.fish
  source $dotfiles/vendor/.iterm2_shell_integration.fish
end
