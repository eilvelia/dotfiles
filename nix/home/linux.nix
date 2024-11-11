{ config, pkgs, lib, ... }:
{
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    clifm
    du-dust
    dut
    ncdu
    nh
    unstable.deno
    zf
  ];
}
