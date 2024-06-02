{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    ../../nixos/generic.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking.hostName = "nixos-qemu-aarch64";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  documentation.enable = false;

  boot.initrd.availableKernelModules = [ "xhci_pci" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = "aarch64-linux";
}
