{ config, pkgs, lib, dotfiles, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ../../home
  ];

  xdg.configFile = {
    "sway" = { recursive = true; source = link "${dotfiles}/sway"; };
    "waybar" = { recursive = true; source = link "${dotfiles}/waybar"; };
  };

  services.udiskie = {
    enable = true;
    notify = false;
    tray = "never"; # temporary
  };
}
