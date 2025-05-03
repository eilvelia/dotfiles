{ config, pkgs, lib, home-manager, ... }:
{
  imports = [
    ../generic.nix
    ./options.nix
    ./sway.nix
    ../containers.nix

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

  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.dbus.enable = true;
  services.dbus.implementation = "broker";
  services.fstrim.enable = lib.mkDefault true;
  services.openssh.enable = false;
  services.pipewire.alsa.enable = true;
  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.udisks2.enable = true;

  networking.networkmanager.wifi.backend = "iwd";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  hardware.bluetooth.settings.General.Experimental = true;
  # services.blueman.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  i18n.defaultLocale = "en_IE.UTF-8";

  systemd.oomd.enable = false;
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 8;
    freeSwapThreshold = 5;
    extraArgs = [
      "--ignore-root-user"
      "--avoid"
      "(^|/)(sway|waybar|swayidle)$"
    ];
    enableNotifications = true;
  };

  networking.timeServers = [ "time.cloudflare.com" ]; 
  services.timesyncd.enable = false;
  services.chrony.enable = !config.boot.isContainer;

  environment.sessionVariables.GTK_THEME = "Adwaita";

  qt.enable = true;
  qt.style = "kvantum";
  # qt.style = "breeze";
  # qt.platformTheme = "qt5ct";
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "gtk3";

  environment.systemPackages = with pkgs; [
    bluetui
    config.boot.kernelPackages.perf
    dmidecode
    evtest
    exfatprogs
    glxinfo
    hdparm
    impala
    libinput
    lm_sensors
    mediainfo
    networkmanagerapplet
    parted
    pciutils
    powertop
    stdenv.cc
    trashy
    udiskie
    xdg-utils

    aria2
    bandwhich
    benzene
    check-sieve
    cmake
    cntr
    cryptsetup
    ffmpeg
    filen-cli
    gdb
    gitFull
    keyd
    magic-wormhole
    nixos-generators
    nixos-rebuild-ng
    nodejs
    openjdk # somewhat large
    poppler-utils # pdf converters
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

    (pkgs.buildFHSEnv (pkgs.appimageTools.defaultFhsEnvArgs // {
      name = "enter-fhs";
      profile = ''
        export FHS=1
      '';
      runScript = "fish";
    }))

    # various GUI apps
    bruno
    cheese
    electrum
    feather
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
    logseq # somewhat large
    mpv
    obs-studio # large
    pavucontrol
    playerctl
    pwvucontrol
    qbittorrent
    qimgv
    ripdrag
    signal-desktop
    sqlitebrowser
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
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="font">
            <test name="family" compare="eq" ignore-blanks="true">
              <string>Fira Code</string>
            </test>
            <edit name="fontfeatures" mode="append">
              <string>liga off</string>
              <string>dlig off</string>
            </edit>
          </match>

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
      '' + ''
        </fontconfig>
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
  programs.kdeconnect.enable = true;
  programs.localsend.enable = true;
  programs.npm.enable = true;
  programs.steam.enable = true; # large; unfree
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark; # a bit large

  services.keybase.enable = true;
  environment.sessionVariables.NIX_SKIP_KEYBASE_CHECKS = "1";

  services.speechd.enable = lib.mkForce false; # save ~690 MiB

  custom.tldr.autoUpdate = true;

  programs.nix-ld.libraries = with pkgs; [
    python3

    # gui-specific
    dbus
    fontconfig
    freetype
    libGL
    libxkbcommon
    xorg.libX11
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

  programs.firefox = {
    enable = true;
    preferencesStatus = "user";
    preferences = {
      # see also:
      # https://github.com/arkenfox/user.js/blob/master/user.js
      # https://github.com/yokoffing/Betterfox

      # Disable autoupdate and a few annoyances
      "app.update.auto" = false;
      "browser.aboutConfig.showWarning" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.privatebrowsing.vpnpromourl" = "";

      # Disable unused services
      "browser.ml.chat.enabled" = false;
      "extensions.pocket.enabled" = false;

      # UI
      "accessibility.force_disabled" = 1;
      # "apz.overscroll.enabled" = false; # NOTE: cannot be set via policies
      "browser.compactmode.show" = true; # show compact mode
      "browser.startup.page" = 1; # home as the startup page (default)
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.ctrlTab.sortByRecentlyUsed" = true;

      "browser.tabs.unloadOnLowMemory" = true;

      "dom.security.https_only_mode" = true; # HTTPS-everywhere
      "network.ttr.mode" = 2; # DNS over HTTPS: increased

      "intl.accept_languages" = "en-ie,en";
      "intl.regional_prefs.use_os_locales" = true;

      # Location bar
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.addons.featureGate" = false;
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.quicksuggest.scenario" = "history";
      "browser.urlbar.showSearchSuggestionsFirst" = false;
      "browser.urlbar.speculativeConnect.enabled" = true;
      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.trending.featureGate" = false;
      "browser.urlbar.unitConversion.enabled" = true;
      "browser.urlbar.yelp.featureGate" = false;
      "browser.formfill.enable" = false; # disable search and form history

      # Prefetching-related
      "network.dns.disablePrefetch" = false; # (default)
      "network.http.speculative-parallel-limit" = 10;
      "network.preconnect" = true;
      "network.predictor.enabled" = false;
      "network.prefetch-next" = false;

      # Privacy-related
      "browser.contentblocking.category" = "strict"; # Enhanced Tracking Protection
      "browser.discovery.enabled" = false;
      "browser.newtabpage.activity-stream.default.sites" = "";
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.safebrowsing.downloads.remote.enabled" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "network.http.referer.XOriginTrimmingPolicy" = 2;
      "signon.formlessCapture.enabled" = false;
      "signon.management.page.breach-alerts.enabled" = false;
      "signon.rememberSignons" = false;

      # Telemetry-related
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
    };
    policies = {
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
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
}
