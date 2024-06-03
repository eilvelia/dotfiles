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
    libraspberrypi # vcgencmd, etc.
  ];

  systemd.services.setleds = {
    script = ''
      echo 'Setting LEDs'
      echo none > /sys/class/leds/ACT/trigger
    '';
    wantedBy = ["multi-user.target"];
  };

  services.openssh.enable = true;

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;

  boot.kernel.sysctl."vm.swappiness" = 150;
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";
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
