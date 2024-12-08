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
    font Inter 12
  '';

  fonts.fontconfig.subpixel.rgba = "rgb";

  environment.sessionVariables.QT_SCALE_FACTOR = "1.25";

  environment.systemPackages = with pkgs; [
    nvme-cli
    nvtopPackages.amd
    radeontop
    sedutil
  ];

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
  ];
  networking.networkmanager.dns = "none";

  # systemd timer for resticprofile backups
  home-manager.users.lambda.systemd.user = {
    services."resticprofile" = {
      Unit = {};
      Service = {
        Type = "oneshot";
        WorkingDirectory = "%h";
        ExecStart = "${lib.getExe pkgs.resticprofile} --no-prio --no-ansi backup";
        Nice = "10";
      };
    };
    timers."resticprofile" = {
      Unit = {
        After = "network-online.target";
      };
      Timer = {
        OnCalendar = "daily";
        Unit = "resticprofile.service";
        Persistent = "true";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };

  services.fstrim.enable = true;
  services.power-profiles-daemon.enable = true;

  # Remap notifications/pickup/hangup to prev/playpause/next media controls
  # Calibrate touchpad
  services.udev.extraHwdb = ''
    evdev:name:ThinkPad Extra Buttons:*
     KEYBOARD_KEY_4b=previoussong
     KEYBOARD_KEY_4c=playpause
     KEYBOARD_KEY_4d=nextsong

    evdev:name:ETPS/2 Elantech Touchpad:*
     EVDEV_ABS_00=::31
     EVDEV_ABS_01=::29
     EVDEV_ABS_35=::31
     EVDEV_ABS_36=::29
  '';

  # # enable opencl. note: bloats closure size
  # hardware.graphics.extraPackages = with pkgs.rocmPackages_5; [
  #   clr
  #   clr.icd
  #   rocm-runtime
  #   rocminfo
  # ];

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
