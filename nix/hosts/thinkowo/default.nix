{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nixos/desktop
  ];

  networking.hostName = "thinkowo";

  environment.etc."sway/pre-config.d/thinkowo.conf".text = ''
    set $text_scaling_factor 1.25
  '';

  environment.etc."sway/config.d/thinkpad.conf".text = ''
    input "2:14:ETPS/2_Elantech_TrackPoint" {
      accel_profile flat
      pointer_accel 0
    }
    input "2:14:ETPS/2_Elantech_Touchpad" {
      click_method clickfinger
    }
    font sans-serif 13
  '';

  fonts.fontconfig.subpixel.rgba = "rgb";

  environment.sessionVariables.QT_SCALE_FACTOR = "1.25";

  environment.systemPackages = with pkgs; [
    radeontop
  ];

  services.fstrim.enable = true;
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options rtw89_pci disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y
    options rtw89_core disable_ps_mode=y
  '';

  boot.kernelParams = [ "acpi_backlight=native" "amd_pstate=active" ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
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

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
