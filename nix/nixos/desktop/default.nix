{ config, pkgs, lib, home-manager, ... }:
{
  imports = [
    ../generic.nix
    ./sway.nix

    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.users.lambda = import ./home.nix;
    }
  ];

  nix.package = pkgs.lix;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    xdg-utils
    lm_sensors
    brightnessctl
    udiskie
    nodejs

    config.boot.kernelPackages.perf

    exfatprogs

    (pkgs.buildFHSUserEnv (pkgs.appimageTools.defaultFhsEnvArgs // {
      name = "fhs";
      profile = ''
        export FHS=1
      '';
      runScript = "fish";
    }))

    zbar # qr codes

    # various GUI apps
    kitty
    chromium
    mpv
    ripdrag
    flameshot
    keepassxc
    thunderbird
    qbittorrent
    signal-desktop
    telegram-desktop
    keybase-gui
    tor-browser
    electrum
    obs-studio
    imhex
    vscode-fhs
    geeqie
    gnome.gnome-calculator # temporary
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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.npm.enable = true;

  services.keybase.enable = true;

  environment.etc."wallpaper.png".source =
    "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  security.polkit.enable = true;

  boot.kernel.sysctl."vm.swappiness" = 150;
  zramSwap.enable = true;
  zramSwap.memoryPercent = lib.mkDefault 150;

  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  services.openssh.enable = lib.mkDefault false;

  services.fstrim.enable = lib.mkDefault true;

  services.udisks2.enable = true;

  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  networking.networkmanager.wifi.backend = "iwd";
}
