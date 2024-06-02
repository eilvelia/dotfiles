{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nixos/generic.nix
  ];

  networking.hostName = "nixpi";

  documentation.man.generateCaches = lib.mkForce false;

  hardware.firmware = [
    pkgs.raspberrypiWirelessFirmware
  ];

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  services.openssh.enable = true;

  networking.firewall.enable = false;
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  boot.kernel.sysctl."vm.swappiness" = 5;
  swapDevices = [{ device = "/var/lib/swapfile"; size = 1024; }];

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
