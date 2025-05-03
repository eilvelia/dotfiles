{ pkgs, lib, ... }:
{
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    caligula
    difftastic
    elan
    gh
    graphviz
    jujutsu
    lua-language-server
    ninja
    ranger
    rclone
    restic
    rizin
    scrypt
    tokei
    typst
    weechat

    unstable.helix
    unstable.opam
    unstable.resticprofile
  ];
}
