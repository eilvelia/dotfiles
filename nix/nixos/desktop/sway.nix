{ config, pkgs, lib, ... }:

# https://nixos.wiki/wiki/Sway

{
  environment.systemPackages = with pkgs; [
    wayland
    swaylock
    swayidle
    glib # gsettings
    adwaita-icon-theme  # default gnome cursors
    wl-clipboard # wl-copy and wl-paste
    waybar
    grim # screenshot functionality
    slurp # screenshot functionality
    mako # notifications
    wdisplays # tool to configure displays
    glfw-wayland
    wf-recorder
    fuzzel # TODO: try anyrun?
    hyprpicker
    wlsunset
    wl-clip-persist
  ];

  services.gnome.gnome-keyring.enable = true;

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
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
  };

  # environment.sessionVariables = {
  #   WLR_NO_HARDWARE_CURSORS = "1";
  # };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # programs.uwsm.enable = true;
  # programs.uwsm.waylandCompositors.sway = {
  #   prettyName = "Sway";
  #   comment = "Sway compositor managed by UWSM";
  #   binPath = "/run/current-system/sw/bin/sway";
  # };

  services.displayManager.enable = true;

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

  # security.pam.loginLimits = [
  #   { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  # ];
}
