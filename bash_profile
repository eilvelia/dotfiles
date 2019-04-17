[[ -s ~/.bashrc ]] && source ~/.bashrc

alias ls="ls -FA"
alias npmplease="rm -rf node_modules/ package-lock.json && npm install"
alias pnpmflat="pnpm install --shamefully-flatten"
alias killflow="killall -9 flow"
alias npmr="npm run"
alias sha256sum="shasum -a 256"

alias totarbz2="tar cjvf"
alias fromtarbz2="tar xjvf"

alias gpg="LANG=en gpg"
alias git="LANG=en git"

alias start_postgres="pg_ctl -D /usr/local/var/postgres start"
alias stop_postgres="pg_ctl -D /usr/local/var/postgres stop"

alias start_redis="redis-server /usr/local/etc/redis.conf"

# gpg symmetric encrypt
alias gpgenc="gpg -c --s2k-mode 3 --s2k-digest-algo sha512 --s2k-count 65011712 --s2k-cipher-algo aes256"

__lambda="λ"
__dotfiles="$HOME/dotfiles"
__system_ocaml_file="$__dotfiles/system_ocaml_path"
__default_user_file="$__dotfiles/default_user"

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
#export LSCOLORS=GxFxCxDxBxegedabagaced
export LS_COLORS=$LSCOLORS

export GPG_TTY=$(tty)
export LESSCHARSET=utf-8
export HISTCONTROL=ignoreboth

__default_user=$(test -r "$__default_user_file" && \
  cat "$__default_user_file" || echo "")

function __prompt {
  local BLACK="\[\033[0;30m\]"
  local BLACKBOLD="\[\033[1;30m\]"
  local RED="\[\033[0;31m\]"
  local REDBOLD="\[\033[1;31m\]"
  local GREEN="\[\033[0;32m\]"
  local GREENBOLD="\[\033[1;32m\]"
  local YELLOW="\[\033[0;33m\]"
  local YELLOWBOLD="\[\033[1;33m\]"
  local BLUE="\[\033[0;34m\]"
  local BLUEBOLD="\[\033[1;34m\]"
  local PURPLE="\[\033[0;35m\]"
  local PURPLEBOLD="\[\033[1;35m\]"
  local CYAN="\[\033[0;36m\]"
  local CYANBOLD="\[\033[1;36m\]"
  local WHITE="\[\033[0;37m\]"
  local WHITEBOLD="\[\033[1;37m\]"
  local RESETCOLOR="\[\e[00m\]"

  local __git_branch='`git branch 2> /dev/null | grep ^* | sed -e "s/* \(.*\)/ (\1)/"`'

  local __user='`[[ "$__default_user" == "\u" ]] && echo $__lambda || echo "\u"`'

  export PS1="$GREEN$__user $YELLOW\w$CYAN$__git_branch$RESETCOLOR \\$ "
}

__prompt

source "$__dotfiles/git-completion.bash"
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

__system_ocaml_path=$(test -r "$__system_ocaml_file" && \
  cat "$__system_ocaml_file" || echo "")

if test -d "$__system_ocaml_path"; then
  export PATH="$__system_ocaml_path:$PATH"
fi

# OPAM configuration
. ~/.opam/opam-init/init.sh &> /dev/null || true

if test -r "$__dotfiles/iterm2_shell_integration.bash"; then
  source "$__dotfiles/iterm2_shell_integration.bash"
fi
