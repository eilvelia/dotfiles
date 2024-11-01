{ config, pkgs, lib, ... }:
{
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    clifm
    ncdu
    nh
    unstable.deno
    zf
  ];
}
