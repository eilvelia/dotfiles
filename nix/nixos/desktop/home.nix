{ config, pkgs, lib, dotfiles, link, ... }:
{
  imports = [
    ../../home/linux.nix
  ];

  home.packages = with pkgs; [
    lolcat
    syncthing

    # custom packages
    hlesspass
  ];

  xdg.configFile = {
    "sway".source = link "${dotfiles}/sway";
    "waybar".source = link "${dotfiles}/waybar";
    "anyrun".source = link "${dotfiles}/anyrun";

    "flameshot/flameshot.ini".text = ''
      [General]
      disabledGrimWarning=true
      disabledTrayIcon=true
      showDesktopNotification=false
    '';

    "udiskie/config.yml".text = ''
      program_options:
        automount: true
        notify: false
        tray: true
    '';
  };

  # note: does not actually show tray icons
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  services.syncthing.enable = true;
}
