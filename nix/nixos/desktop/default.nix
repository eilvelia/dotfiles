{ config, pkgs, lib, home-manager, ... }:
{
  imports = [
    ../generic.nix
    ./sway.nix

    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.users.lambda = import ./home.nix;
      home-manager.backupFileExtension = "hm-backup";
    }
  ];

  nix.package = pkgs.lix;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  nixpkgs.config.allowUnfree = true;

  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  services.openssh.enable = false;

  services.fstrim.enable = lib.mkDefault true;

  security.polkit.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  networking.networkmanager.wifi.backend = "iwd";

  services.udisks2.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  environment.sessionVariables.GTK_THEME = "Adwaita";

  systemd.oomd.enable = false;
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 8;
    freeSwapThreshold = 5;
    extraArgs = [
      "--ignore-root-user"
      "--avoid '(^|/)(sway|waybar|swayidle)$'"
    ];
    enableNotifications = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    config.boot.kernelPackages.perf
    exfatprogs
    glxinfo
    lm_sensors
    parted
    pciutils
    udiskie
    xdg-utils

    gitFull
    nodejs
    python3
    tor
    zbar # qr codes

    (pkgs.buildFHSUserEnv (pkgs.appimageTools.defaultFhsEnvArgs // {
      name = "fhs";
      profile = ''
        export FHS=1
      '';
      runScript = "fish";
    }))

    # various GUI apps
    bruno
    chromium
    electrum
    imhex
    imv
    keepassxc
    keybase-gui
    kitty
    krita # large
    localsend
    logseq
    mpv
    obs-studio # large
    pavucontrol
    playerctl
    pwvucontrol
    qbittorrent
    qimgv
    ripdrag
    signal-desktop
    sublime-merge # unfree
    telegram-desktop
    thunderbird
    tor-browser
    vscode-fhs # unfree
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11" # for logseq
  ];

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      # notes:
      # helvetica-neue-lt-std seems to have issues with vertical alignment
      # noto-fonts are disabled because github grabs them instead of
      #            better-looking ones
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      charis-sil
      fira-code
      font-awesome
      freefont_ttf
      gyre-fonts
      noto-fonts-color-emoji
      roboto
      terminus_font_ttf
      unifont
    ];
    # Enabling this seems to build xwayland from source
    # fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Roboto" ];
        serif = [ "Charis SIL" ];
        monospace = [ "Fira Code" ];
      };
      localConf = ''
        <match target="pattern">
          <test qual="any" name="family">
            <string>Helvetica</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Roboto</string>
          </edit>
        </match>
      '';
    };
  };

  xdg = {
    mime.enable = true;
    mime.defaultApplications = {
      "inode/directory" = [ "kitty-open.desktop" ];
      "video/webm" = "qimgv.desktop";
      "image/jpeg" = "qimgv.desktop";
      "image/gif" = "qimgv.desktop";
      "image/png" = "qimgv.desktop";
      "image/bmp" = "qimgv.desktop";
      "image/webp" = "qimgv.desktop";
    };
    terminal-exec.enable = true;
    terminal-exec.settings.default = [ "kitty.desktop" ];
  };

  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [
  #   8080 # local web servers
  #   22000 # syncthing
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   21027 22000 # syncthing
  # ];

  environment.etc."gitconfig".text = ''
    [credential]
      helper = libsecret
  '';

  programs.npm.enable = true;
  programs.localsend.enable = true;

  services.keybase.enable = true;
  environment.sessionVariables.NIX_SKIP_KEYBASE_CHECKS = "1";

  systemd.user.timers."tldr-update" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    unitConfig = {
      After = "network-online.target";
    };
  };

  systemd.user.services."tldr-update" = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.tldr}/bin/tldr --update";
    };
  };
}
