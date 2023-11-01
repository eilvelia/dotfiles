function fish_prompt
  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  switch "$USER"
    case root toor
      if not set -q __fish_prompt_cwd
        if set -q fish_color_cwd_root
          set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
        else
          set -g __fish_prompt_cwd (set_color $fish_color_cwd)
        end
      end
      set prompt_sign '#'

    case '*'
      if not set -q __fish_prompt_cwd
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
      end
      set prompt_sign '$'
  end

  if set -q RANGER_LEVEL
    set ranger (set_color cyan) " [ranger]" $__fish_prompt_normal
  end

  if set -q IN_NIX_SHELL
    set nix_indicator (set_color brcyan) " [nix]" $__fish_prompt_normal
  end

  if test "$LC_TERMINAL" != "iTerm2"
    set git_branch (set_color cyan) (fish_git_prompt) $__fish_prompt_normal
  end

  echo -n -s "$__fish_prompt_cwd" (prompt_pwd) $__fish_prompt_normal \
    $git_branch $nix_indicator $ranger " $prompt_sign "
end
