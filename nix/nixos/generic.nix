# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{ config, pkgs, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = lib.mkDefault "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = lib.mkDefault "Etc/UTC";

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.lambda = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ]; # Enable 'sudo' for the user.
    packages = [];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDV5YFxhv784mta82xDgWHCZ3IHGCT/4bNv/CvZ12amr"
    ];
  };
  users.users.root.password = null;
  users.mutableUsers = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    fish
    rsync
    psmisc # pstree, killall, etc.
    bind # dig, nslookup, etc.
    neofetch
    file
    stdenv.cc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  security.sudo.configFile = ''
    Defaults env_keep += "TERM TERMINFO"
    Defaults env_keep += "SSH_TTY"
    Defaults env_keep += "EDITOR VISUAL LS_COLORS"
  '';

  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #   stdenv.cc.cc
    # ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
