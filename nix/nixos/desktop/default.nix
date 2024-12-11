{ config, pkgs, lib, home-manager, ... }:
{
  imports = [
    ../generic.nix
    ./options.nix
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

  i18n.defaultLocale = "en_IE.UTF-8";

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
    config.boot.kernelPackages.perf
    dmidecode
    evtest
    exfatprogs
    glxinfo
    hdparm
    libinput
    lm_sensors
    mediainfo
    openssl
    parted
    pciutils
    powertop
    trashy
    udiskie
    xdg-utils

    bandwhich
    benzene
    cryptsetup
    ffmpeg
    gitFull
    keyd
    nodejs
    openjdk # somewhat large
    stress
    tor
    yt-dlp
    zbar # qr codes

    # packaging-related stuff
    nix-init
    nix-update
    nixfmt-rfc-style
    nixpkgs-review
    nurl

    (pkgs.buildFHSUserEnv (pkgs.appimageTools.defaultFhsEnvArgs // {
      name = "fhs";
      profile = ''
        export FHS=1
      '';
      runScript = "fish";
    }))

    # various GUI apps
    bruno
    cheese
    electrum
    google-chrome # unfree
    gparted
    hexgui # depends on java
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
  ] ++ lib.optionals config.custom.enableCustomPackages [
    hlesspass
    katahex19CPUAVX2
    katahexCPUAVX2
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
      charis-sil
      fira-code
      fira-sans
      font-awesome
      freefont_ttf
      gohufont
      gyre-fonts
      inter
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      roboto
      terminus_font
      terminus_font_ttf
      unifont
    ];
    # Enabling this seems to build xwayland from source
    # fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        sansSerif = [ config.custom.defaultFont ];
        serif = [ "Charis SIL" ];
        monospace = [ "Fira Code" ];
      };
      localConf = ''
        <match target="pattern">
          <test qual="any" name="family">
            <string>Helvetica</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>${config.custom.defaultFont}</string>
          </edit>
        </match>
      '' + lib.optionalString (config.custom.defaultFont != "Roboto") ''
        <match target="pattern">
          <test qual="any" name="family">
            <string>Roboto</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>${config.custom.defaultFont}</string>
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

  programs.gnome-disks.enable = true;
  programs.localsend.enable = true;
  programs.npm.enable = true;
  programs.steam.enable = true; # large; unfree

  services.keybase.enable = true;
  environment.sessionVariables.NIX_SKIP_KEYBASE_CHECKS = "1";

  services.speechd.enable = lib.mkForce false; # save ~690 MiB

  # for java apps
  environment.sessionVariables."AWT_TOOLKIT" = "MToolkit";
  environment.sessionVariables."_JAVA_AWT_WM_NONREPARENTING" = "1";

  programs.nix-ld.libraries = with pkgs; [
    python3

    # gui-specific
    dbus
    fontconfig
    freetype
    libGL
    libxkbcommon
    xorg.libX11
    wayland
  ];

  services.keyd.enable = true;
  services.keyd.keyboards = {
    default = {
      ids = [ "*" ];
      settings = {
        global = {
          oneshot_timeout = "1500";
        };
        main = {
          capslock = "esc";
          esc = "layer(esc)";

          # swap left alt and left win (left win is used for common WM keybinds)
          leftalt = "leftmeta";
          leftmeta = "leftalt";

          # sticky right modifier
          rightalt = "oneshot(rmod)";
        };
        esc = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          c = "capslock";
        };
        rmod = {
          d = "macro(iso-level3-shift+d)";
          s = "macro(iso-level3-shift+s)";

          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };

  # polkit authentication agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };

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
