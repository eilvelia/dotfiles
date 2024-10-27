function fish_prompt
  set -q __fish_prompt_normal
    or set -g __fish_prompt_normal (set_color normal)

  set -l cwd_color (set_color $fish_color_cwd)
  set -l prompt_sign '$'

  if test "$USER" = "root" -o "$USER" = "toor"
    set -q fish_color_cwd_root
      and set cwd_color (set_color $fish_color_cwd_root)
    set prompt_sign '#'
  end

  set -q SSH_TTY || set -q SSH_CLIENT
    and set -l host (set_color brgreen)(prompt_hostname)$__fish_prompt_normal

  set -l cwd $cwd_color(prompt_pwd)$__fish_prompt_normal

  set -l git_branch \
    (fish_git_prompt (set_color cyan)"(%s)"$__fish_prompt_normal)

  set -q IN_NIX_SHELL
    and set -l nix_indicator (set_color brcyan)"[nix]"$__fish_prompt_normal

  set -q RANGER_LEVEL
    and set -l ranger_indicator (set_color cyan)"[ranger]"$__fish_prompt_normal

  echo -n $host $cwd $git_branch \
    $nix_indicator $ranger_indicator $prompt_sign ''
end
