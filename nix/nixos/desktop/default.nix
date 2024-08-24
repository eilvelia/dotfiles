{ config, pkgs, lib, ... }:
{
  imports = [
    ../generic.nix
    ./sway.nix
  ];

  # Enable sound.
  sound.enable = true;

  environment.systemPackages = with pkgs; [
    rsnapshot
    xdg-utils

    # GUI apps
    chromium
    kitty
    geeqie
    mpv
    ripdrag
    flameshot
    keepassxc
    qbittorrent
    telegram-desktop
    keybase-gui
    tor-browser
  ];

  services.keybase.enable = true;

  environment.etc."wallpaper.png".source =
    "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png";

  fonts.packages = with pkgs; [
    fira-code
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    noto-fonts
  ];

  boot.kernel.sysctl."vm.swappiness" = 150;
  zramSwap.enable = true;
  zramSwap.memoryPercent = lib.mkDefault 100;
}
