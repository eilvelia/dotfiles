{ config, pkgs, lib, home-manager, nixos-hardware, ... }:
{
  imports = [
    ../../nixos/server

    nixos-hardware.nixosModules.raspberry-pi-3

    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.users.lambda = import ../../home/base.nix;
      home-manager.backupFileExtension = "hm-backup";
    }
  ];

  networking.hostName = "nixpi";

  nix.settings.trusted-users = [ "@wheel" ];

  documentation.man.generateCaches = lib.mkForce false;

  hardware.firmware = with pkgs; [
    raspberrypiWirelessFirmware
  ];

  environment.systemPackages = with pkgs; [
    libgpiod
    libraspberrypi # vcgencmd, etc.
    lm_sensors
  ];

  systemd.services.setleds = {
    script = ''
      echo 'Setting LEDs'
      echo none > /sys/class/leds/ACT/trigger
      if [ -e /sys/class/leds/PWR/trigger ]; then
        echo none > /sys/class/leds/PWR/trigger
      fi
    '';
    wantedBy = ["multi-user.target"];
  };

  services.openssh.enable = true;

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;

  zramSwap.memoryPercent = 250;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  nixpkgs.hostPlatform = "aarch64-linux";
}
