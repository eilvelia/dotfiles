{ pkgs, lib, ... }:
{
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    caligula
    difftastic
    elan
    ffsend
    gh
    glow
    graphviz
    helix
    jujutsu
    lua-language-server
    most
    ninja
    rakudo
    ranger
    rclone
    restic
    resticprofile
    rizin
    scrypt
    tokei
    typst
    weechat
    yazi
  ];
}
