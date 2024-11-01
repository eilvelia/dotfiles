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

  nixpkgs.config.allowUnfree = true;

  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  services.openssh.enable = lib.mkDefault false;

  services.fstrim.enable = lib.mkDefault true;

  boot.kernel.sysctl."vm.swappiness" = 150;
  zramSwap.enable = true;
  zramSwap.memoryPercent = lib.mkDefault 150;

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
    flameshot
    imhex
    imv
    keepassxc
    keybase-gui
    kitty
    localsend
    logseq
    mpv
    obs-studio # note: the size of it is pretty large
    pavucontrol
    playerctl
    pwvucontrol
    qbittorrent
    qimgv
    ripdrag
    signal-desktop
    telegram-desktop
    thunderbird
    tor-browser
    vscode-fhs
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11" # for logseq
  ];

  fonts = {
    packages = with pkgs; [
      fira-code
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      font-awesome
      # noto-fonts
      # noto-fonts-cjk
      noto-fonts-color-emoji
      roboto
      # helvetica-neue-lt-std # seems to have issues with vertical alignment
      charis-sil
      # corefonts
      unifont
    ];
    # Enabling this seems to build xwayland from source
    # fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Roboto" ];
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

  networking.firewall.allowedTCPPorts = [ 22000 ]; # for syncthing
  networking.firewall.allowedUDPPorts = [ 21027 22000 ]; # for syncthing

  environment.etc."gitconfig".text = ''
    [credential]
      helper = libsecret
  '';

  programs.npm.enable = true;
  programs.localsend.enable = true;

  services.keybase.enable = true;
  environment.sessionVariables.NIX_SKIP_KEYBASE_CHECKS = "1";
}
