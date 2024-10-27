{ config, pkgs, lib, ... }:

# https://nixos.wiki/wiki/Sway

{
  environment.systemPackages = with pkgs; [
    wayland
    swaylock
    swayidle
    glib # gsettings
    gnome.adwaita-icon-theme  # default gnome cursors
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
    pavucontrol
    pwvucontrol
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
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # extraSessionCommands = ''
    #   source /etc/profile
    #   test -f $HOME/.profile && source $HOME/.profile
    #   export MOZ_ENABLE_WAYLAND=1
    # '';
  };

  # environment.sessionVariables = {
  #   WLR_NO_HARDWARE_CURSORS = "1";
  # };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # TODO: Use uwsm

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --cmd sway";
        user = "greeter";
      };
    };
  };

  # security.pam.loginLimits = [
  #   { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  # ];

  hardware.opengl.enable = true;
}
