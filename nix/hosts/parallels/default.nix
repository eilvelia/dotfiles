{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nixos/desktop
  ];

  networking.hostName = "nixos-parallels";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "prl-tools" ];

  hardware.parallels.enable = true;

  boot.initrd.availableKernelModules = [ "uhci_hcd" "xhci_pci" "ehci_pci" "ata_piix" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
