status is-interactive || exit

set -l dotfiles ~/dotfiles
set -g __uname (uname)
set -l uname $__uname

set fish_greeting

# The default is Alt-e / Alt-v (which still works)
bind \cx\ce edit_command_buffer

# gpg symmetric encrypt
alias gpgenc "gpg -c --s2k-mode 3 --s2k-digest-algo sha512 --s2k-count 65011712 --s2k-cipher-algo aes256 --no-symkey-cache"

# light nvim + "private" mode
alias lvi "nvim --cmd 'let g:min_mode = 1' -i NONE --cmd 'set noswapfile'"

alias ls "ls -FAhv --color=auto --group-directories-first"
alias tree "tree -a"
alias fd "fd --hidden --no-ignore-vcs"

abbr -ag delta-unified "DELTA_FEATURES='' delta"
abbr -ag getdate "date \"+%Y-%m-%d\""

abbr -ag gs "git status"
abbr -ag go "git switch"

abbr -ag ez "eza --all -l --git"
abbr -ag eza-tree "eza --tree -l --all --git -I '.git' --color=always --icons=auto"

abbr -ag to-tar-zstd "tar c --zstd -f .tar.zst"
abbr -ag to-tar-gz "tar c --gzip -f .tgz"
abbr -ag to-tar-bz2 "tar c --bzip2 -f .tbz2"
abbr -ag to-tar "tar c -af"
abbr -ag from-tar "tar x -f"

abbr -ag cdtmp "cd (mktemp -d)"
abbr -ag qfind "find . -name"
abbr -ag f "ls | grep -i"

abbr -ag npmr "npm run"
abbr -ag youtube-music "yt-dlp --extract-audio"
abbr -ag d "ripdrag -Axn"

if test "$uname" = "Linux"
  abbr -ag t "trash put"

  # basic bwrap command (for nixos), not necessarily the most secure
  # note: --new-session isn't here because that breaks ctrl+c
  abbr -ag basic-bwrap bwrap --die-with-parent \
    --unshare-pid --unshare-ipc --unshare-uts --proc /proc --dev /dev \
    --tmpfs /tmp --tmpfs /run --tmpfs /var --tmpfs '"$HOME"' \
    --ro-bind /bin /bin --ro-bind /usr/bin /usr/bin --ro-bind /etc /etc \
    --ro-bind-try /nix /nix --ro-bind-try /run/current-system/sw /run/current-system/sw \
    --bind-try "~/sandbox" "~/sandbox" \
    "(which bash)"

  abbr -ag readall-shell 'sudo capsh --keep=1 --user=$USER --inh=cap_dac_read_search --addamb=cap_dac_read_search -- -c $SHELL'
end

if test "$TERM" = "xterm-kitty"
  abbr -ag icat "kitten icat"
end

set -gx CLICOLOR 1
set -gx LSCOLORS gxbxhxdxfxhxhxhxhxcxcx
set -gx LS_COLORS "di=36:ln=31:so=37:pi=33:ex=35:bd=37:cd=37:su=37:sg=37:tw=32:ow=32"

set -gx VISUAL nvim
set -gx EDITOR nvim

set -gx LESSHISTFILE "-"
set -gx LESSCHARSET utf-8
set -gx LESSKEYIN $LESSKEYIN_SYSTEM

test -r ~/.inputrc; and set -gx INPUTRC ~/.inputrc

set -gx RIPGREP_CONFIG_PATH $dotfiles/ripgreprc

set -gx NIXPKGS_ALLOW_UNFREE 1

set -gx OPAMNODEPEXTS 1

if not set -q __fish_config_path_set
  set -xp PATH $dotfiles/global-scripts
  test -d ~/.local/bin;   and set -xp PATH ~/.local/bin
  test -d ~/.cargo/bin;   and set -xp PATH ~/.cargo/bin
  test -d ~/.juliaup/bin; and set -xp PATH ~/.juliaup/bin
  test -d ~/.npm/bin;     and set -xp PATH ~/.npm/bin
  test -d ~/.dune/bin;    and set -xp PATH ~/.dune/bin
  test -d ~/.ghcup/bin;   and set -xp PATH ~/.ghcup/bin
  set -gx __fish_config_path_set 1
end

if test "$uname" = "Linux"
  set -g drive /run/media/$USER
else if test "$uname" = "Darwin"
  set -gx LANG en_US.UTF-8
  set -gx GPG_TTY (tty)
  set -gx HOMEBREW_NO_AUTO_UPDATE 1
  set -gx NPM_CONFIG_GLOBALCONFIG "/etc/npmrc"
  if status is-login
    # if test "$LC_TERMINAL" = "iTerm2"
    #   and test -r $dotfiles/vendor/.iterm2_shell_integration.fish
    #   source $dotfiles/vendor/.iterm2_shell_integration.fish
    # end
    if test -d ~/.nix-profile/lib
      set -xp DYLD_FALLBACK_LIBRARY_PATH ~/.nix-profile/lib
    end
  end
end

# Theme setup
if not set -q __fish_theme_set
  # Based on Monokai Pro
  set -g fish_color_autosuggestion 727072
  set -g fish_color_cancel -r
  set -g fish_color_command a9dc76
  set -g fish_color_comment 727072
  set -g fish_color_cwd ffd866
  set -g fish_color_cwd_root ff6188
  set -g fish_color_end 939293
  set -g fish_color_error 7a9c56
  set -g fish_color_escape ab9df2
  set -g fish_color_history_current --bold
  set -g fish_color_host normal
  set -g fish_color_host_remote fc9867
  set -g fish_color_keyword ff6188
  set -g fish_color_match --background=403e41
  set -g fish_color_normal fcfcfa
  set -g fish_color_operator ab9df2
  set -g fish_color_option fc9867
  set -g fish_color_param 78dce8
  set -g fish_color_quote ffd866
  set -g fish_color_redirection ab9df2 --bold
  set -g fish_color_search_match fcfcfa --background=403e41
  set -g fish_color_selection fcfcfa --bold --background=403e41
  set -g fish_color_status ff6188
  set -g fish_color_user a9dc76
  set -g fish_color_valid_path --underline
  set -g fish_pager_color_background
  set -g fish_pager_color_completion fcfcfa
  set -g fish_pager_color_description ffd866 -i
  set -g fish_pager_color_prefix fcfcfa --bold --underline
  set -g fish_pager_color_progress fcfcfa --background=403e41
  set -g fish_pager_color_secondary_background
  set -g fish_pager_color_secondary_completion
  set -g fish_pager_color_secondary_description
  set -g fish_pager_color_secondary_prefix
  set -g fish_pager_color_selected_background -r
  set -g fish_pager_color_selected_completion
  set -g fish_pager_color_selected_description
  set -g fish_pager_color_selected_prefix

  set -g __fish_color_branch ab9df2

  set -g __fish_theme_set 1
end

test -r ~/.opam/opam-init/init.fish
  and source ~/.opam/opam-init/init.fish &> /dev/null || true

# Show [exit status: XX] at the end of a command
set -q __fish_last_status_generation
  or set -g __fish_last_status_generation $status_generation
function fish_print_error_status --on-event fish_postexec
  set -l last_status $status
  if test $last_status -ne 0 -a $last_status -lt 126 -a \
     $__fish_last_status_generation -ne $status_generation
    echo (set_color $fish_color_status)"[exit status: $last_status]$__fish_prompt_normal"
  end
  set -g __fish_last_status_generation $status_generation
end
