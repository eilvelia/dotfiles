{ config, pkgs, lib, nixos-hardware,... }:
{
  imports = [
    ../../nixos/desktop
    nixos-hardware.nixosModules.common-gpu-intel
    # nixos-hardware.nixosModules.common-gpu-nvidia-disable
  ];

  networking.hostName = "eastretosh";

  boot.kernelParams = [ "hid_apple.iso_layout=0" ];

  services.fstrim.enable = true;
  services.mbpfan.enable = lib.mkForce false;

  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [ vaapiVdpau ];

  environment.variables.LIBVA_DRIVER_NAME = "i915";

  environment.systemPackages = with pkgs; [ gpu-switch intel-gpu-tools ];

  # note: intel gpu will only display graphics if the device is switched to it
  # (using gpu-switch or gfxCardStatus)

  # Disabling the nvidia dGPU (https://nixos.wiki/wiki/Nvidia)
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';
  # services.udev.extraRules = ''
  #   # Remove NVIDIA Audio devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
  #   # Remove NVIDIA VGA/3D controller devices
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0300[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  # '';
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

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

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
