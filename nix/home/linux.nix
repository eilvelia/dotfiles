{ config, pkgs, lib, ... }:
{
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    clifm
    du-dust
    dut
    inxi
    ncdu
    nh
    unstable.deno
    zf
  ];
}
