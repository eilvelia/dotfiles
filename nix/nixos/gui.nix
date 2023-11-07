{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    chromium
    kitty
    ripdrag
    flameshot
  ];

  # NOTE: Renamed to fonts.packages in newer versions of NixOS
  fonts.fonts = with pkgs; [
    fira-code
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    noto-fonts
  ];
}
