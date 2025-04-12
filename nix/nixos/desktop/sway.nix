{ config, pkgs, lib, ... }:
{
  # https://nixos.wiki/wiki/Sway
  # https://wiki.nixos.org/wiki/Sway

  # > xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # > known as portals under a well-known name
  # > (org.freedesktop.portal.Desktop) and object path
  # > (/org/freedesktop/portal/desktop).
  # > The portal interfaces include APIs for file access, opening URIs,
  # > printing and others.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SWAY_DEFAULT_WALLPAPER=/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png
    '';
    extraPackages = with pkgs; [
      # defaults:
      brightnessctl
      foot
      grim
      pulseaudio
      swayidle
      swaylock
      wmenu

      adwaita-icon-theme # default gnome cursors
      anyrun # runner
      dconf-editor # edit gnome settings
      glfw-wayland
      glib # gsettings
      hyprpicker # color picker from hyprland
      mako # notifications
      satty # screenshot tool
      slurp # select a region; to be used with grim
      sway-overfocus # https://github.com/korreman/sway-overfocus
      waybar # swaybar alternative
      wayland
      wdisplays # tool to configure displays
      wev # show wayland events
      wf-recorder # screen recorder
      wl-clip-persist # simple clipboard persister for wayland
      wl-clipboard # wl-copy and wl-paste
      wlsunset # auto-adjust display's color temperature
    ];
  };

  # environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # for java apps
  environment.sessionVariables."AWT_TOOLKIT" = "MToolkit";
  environment.sessionVariables."_JAVA_AWT_WM_NONREPARENTING" = "1";

  programs.nix-ld.libraries = [ pkgs.wayland ];

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true; # gui for managing keys in gnome-keyring
  security.pam.services.swaylock.enableGnomeKeyring = true;

  # programs.uwsm.enable = true;
  # programs.uwsm.waylandCompositors.sway = {
  #   prettyName = "Sway";
  #   comment = "Sway compositor managed by UWSM";
  #   binPath = "/run/current-system/sw/bin/sway";
  # };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = builtins.concatStringsSep " " [
          "${pkgs.greetd.tuigreet}/bin/tuigreet"
          "--time --remember --remember-session"
          "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
        ];
        user = "greeter";
      };
    };
  };

  security.pam.services.greetd.text = lib.mkForce ''
    auth      substack      login
    account   include       login
    password  substack      login
    session   include       login
  '';

  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];
}
