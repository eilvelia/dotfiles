if not status --is-interactive
  exit
end

set -l dotfiles ~/dotfiles

set fish_greeting

source $__fish_config_dir/colors.fish

# The default is Alt-e / Alt-v
bind \cx\ce edit_command_buffer

# gpg symmetric encrypt
alias gpgenc "gpg -c --s2k-mode 3 --s2k-digest-algo sha512 --s2k-count 65011712 --s2k-cipher-algo aes256"

# light nvim
alias lvi "nvim --cmd 'let g:min_mode = 1'"

# "private" mode
alias lvi-p "nvim --cmd 'let g:min_mode = 1' -i NONE --cmd 'set noswapfile'"

abbr -ag ez "eza --all -l --git"
abbr -ag eza-tree "eza --tree --git-ignore"

abbr -ag getdate "date \"+%Y_%m_%d\""

abbr -ag qfind "find . -name"

abbr -ag f "ls | grep -i"

abbr -ag to-tar-zstd "tar c --zstd -f .tar.zst"
abbr -ag to-tar-gz "tar c --gzip -f .tgz"
abbr -ag to-tar-bz2 "tar c --bzip2 -f .tbz2"
abbr -ag to-tar-any "tar c -a -f"
abbr -ag from-tar "tar x -f"

abbr -ag gs "git status"

abbr -ag ra "ranger"

abbr -ag hi "highlight"

abbr -ag npmplease "rm -rf node_modules/ package-lock.json && npm install"
abbr -ag pnpmflat "pnpm install --shamefully-flatten"
abbr -ag npmr "npm run"

abbr -ag youtube-music "youtube-dl --extract-audio --audio-format vorbis"

abbr -ag start-postgres "pg_ctl -D /usr/local/var/postgres start"
abbr -ag stop-postgres "pg_ctl -D /usr/local/var/postgres stop"

abbr -ag start-redis "redis-server /usr/local/etc/redis.conf"

set -x LANG en_US.UTF-8

set -x CLICOLOR 1

if test (uname) = "Darwin"
  alias ls "ls -FA"
  abbr -ag sha256sum "shasum -a 256"
else
  alias ls "ls -FA --color=auto"
end

if test "$TERM" = "xterm-kitty"
  set -x LSCOLORS gxbxhxdxfxhxhxhxhxcxcx
  set -x LS_COLORS "di=36:ln=31:so=37:pi=33:ex=35:bd=37:cd=37:su=37:sg=37:tw=32:ow=32"
  abbr -ag icat "kitten icat"
else
  set -x LSCOLORS gxBxhxDxfxhxhxhxhxcxcx
  set -x LS_COLORS "di=36:ln=1;31:so=37:pi=1;33:ex=35:bd=37:cd=37:su=37:sg=37:tw=32:ow=32"
end

set -x VISUAL nvim
set -x EDITOR nvim

set -x GPG_TTY (tty)
set -x LESSCHARSET utf-8
if test -r ~/.inputrc
  set -x INPUTRC ~/.inputrc
end

set -x OPAMNODEPEXTS 1
set -x HOMEBREW_NO_AUTO_UPDATE 1

if status --is-login
  set -xp PATH ~/.local/bin

  set -xp PATH $dotfiles/global-scripts

  if test -d ~/.cargo
    set -xp PATH ~/.cargo/bin
  end

  if test -d ~/.juliaup
    set -xp PATH ~/.juliaup/bin
  end

  source ~/.opam/opam-init/init.fish > /dev/null 2>&1 || true

  if test "$LC_TERMINAL" = "iTerm2"
    and test -r $dotfiles/vendor/.iterm2_shell_integration.fish
    source $dotfiles/vendor/.iterm2_shell_integration.fish
  end
end
