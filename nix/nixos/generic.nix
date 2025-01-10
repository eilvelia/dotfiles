# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{ config, pkgs, lib, ... }:
{
  imports = [
    ./tldr.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # note: builtins.toString is different from string concatenation here
  nix.registry.unstable.to.type = "path";
  nix.registry.unstable.to.path = builtins.toString pkgs.unstable.path;

  nixpkgs.overlays = [ (import ../overlays).default ];

  networking.hostName = lib.mkDefault "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = lib.mkDefault "Etc/UTC";

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.lambda = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ] # Enable 'sudo' for the user.
      ++ lib.optionals config.programs.wireshark.enable [ "wireshark" ];
    packages = [];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDV5YFxhv784mta82xDgWHCZ3IHGCT/4bNv/CvZ12amr"
    ];
  };
  users.users.root.password = null;
  users.mutableUsers = true;

  services.openssh.enable = lib.mkDefault true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;

  boot.kernel.sysctl."vm.swappiness" = 170;
  boot.kernel.sysctl."vm.page-cluster" = 0;
  boot.kernel.sysctl."vm.watermark_boost_factor" = 0;
  boot.kernel.sysctl."vm.watermark_scale_factor" = 125;
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";
  zramSwap.memoryPercent = lib.mkDefault 200;

  environment.systemPackages = with pkgs; [
    bind # dig, nslookup, etc.
    bubblewrap
    file
    fish
    git
    gnumake
    htop
    inxi
    lsof
    ncdu
    neofetch
    openssl
    psmisc # pstree, killall, etc.
    python3
    rsync
    tree
    vim
    wget

    kitty.terminfo
    wezterm.terminfo
  ];

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    LESSHISTFILE = "-";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  # programs.fish enables man caches; this disables it to reduce build times
  documentation.man.generateCaches = lib.mkForce false;

  programs.command-not-found.enable = false;

  custom.tldr.enable = true;

  security.sudo.extraConfig = ''
    Defaults env_keep += "TERM SSH_TTY EDITOR VISUAL LS_COLORS"
  '';
  security.sudo.keepTerminfo = true;

  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #   stdenv.cc.cc
    # ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
