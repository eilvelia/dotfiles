# Based on https://github.com/kidonng/nix.fish/blob/ad57d970841ae4a24521b5b1a68121cf385ba71e/conf.d/nix.fish
# MIT License, Copyright (c) 2020 Kid
# with heavy modifications

set --local profile ~/.nix-profile
set --local default /nix/var/nix/profiles/default
set --local system /run/current-system/sw

if not test -r $profile -o -r $default -o -r $system
  exit
end

# note: support for ~/.nix-defexpr/channels has been removed

if not set -q NIX_SSL_CERT_FILE
  # Also check for /etc/ssl/cert.pem, see https://github.com/NixOS/nix/issues/5461
  for file in /etc/{ssl/{certs/ca-certificates.crt,ca-bundle.pem,certs/ca-bundle.crt},pki/tls/certs/ca-bundle.crt,ssl/cert.pem} $profile/etc/{ssl/certs/,}ca-bundle.crt
    if test -e $file
      set -x NIX_SSL_CERT_FILE $file
      break
    end
  end
end

if not status is-interactive
  exit
end

set -q NIX_PROFILES
  or set -x NIX_PROFILES $profile $default $system

if test -n "$MANPATH" && not contains $profile/share/man $MANPATH
  set --prepend MANPATH $profile/share/man
end

if not contains $system/bin $PATH
  test -d $system/bin; and set -xp PATH $system/bin
  test -d $default/bin; and set -xp PATH $default/bin
  test -d $profile/bin; and set -xp PATH $profile/bin
end

# set --local packages (string match --regex "/nix/store/[\w.-]+" $PATH)

# if test (count $packages) != 0
#   set fish_complete_path $fish_complete_path[1] \
#     $packages/etc/fish/completions \
#     $packages/share/fish/vendor_completions.d \
#     $fish_complete_path[2..]
#   set fish_function_path $fish_function_path[1] \
#     $packages/etc/fish/functions \
#     $packages/share/fish/vendor_functions.d \
#     $fish_function_path[2..]

#   for file in $packages/etc/fish/conf.d/*.fish $packages/share/fish/vendor_conf.d/*.fish
#     if ! test -f (string replace --regex "^.*/" $__fish_config_dir/conf.d/ -- $file)
#       source $file
#     end
#   end
# end
