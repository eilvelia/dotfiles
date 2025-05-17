{ config, pkgs, lib, dotfiles, link, ... }:
{
  imports = [
    ../../home/extra.nix
  ];

  home.packages = with pkgs; [
    clifm
    deno
    lolcat
    syncthing
    zf
  ];

  xdg.configFile = {
    "sway".source = link "${dotfiles}/sway";
    "waybar".source = link "${dotfiles}/waybar";
    "anyrun".source = link "${dotfiles}/anyrun";

    "udiskie/config.yml".text = ''
      program_options:
        automount: true
        notify: true
        tray: true
      notifications:
        device_mounted: 2
        device_unmounted: 1
        device_added: false
        device_removed: false
        job_failed: false
    '';

    "mako/config".text = ''
      default-timeout=7500
      border-radius=6
      font=sans-serif 11
      format=<span size="13pt">%s</span>\n%b

      background-color=#222222
      border-color=#285577

      [grouped]
      format=(%g) %s\n%b

      [urgency=low]
      border-color=#5F676A

      [urgency=high]
      border-color=#287CBD
      default-timeout=0

      [mode=do-not-disturb]
      invisible=1

      [mode=away]
      default-timeout=0
      ignore-timeout=1
    '';

    "satty/config.toml".text = ''
      [general]
      copy-command = "wl-copy"
      disable-notifications = true
      early-exit = true
      save-after-copy = false
    '';

    "Kvantum/kvantum.kvconfig".text = ''
      theme=KvArc
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
