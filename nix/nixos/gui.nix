{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    chromium
    kitty
    ripdrag
    flameshot
    keepassxc
    qbittorrent
    telegram-desktop
  ];

  fonts.packages = with pkgs; [
    fira-code
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    noto-fonts
  ];
}
