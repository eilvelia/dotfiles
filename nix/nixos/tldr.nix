{ config, pkgs, lib, ... }:
let cfg = config.custom.tldr; in
{
  options.custom.tldr = {
    enable = lib.mkEnableOption ''
      tldr installation
    '';
    package = lib.mkPackageOption pkgs "tealdeer" { };
    autoUpdate = lib.mkEnableOption ''
      automatic update
    '';
    autoUpdateCalendar = lib.mkOption {
      type = lib.types.str;
      default = "weekly";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user = lib.mkIf cfg.autoUpdate {
      timers."tldr-update" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.autoUpdateCalendar;
          Persistent = true;
        };
        unitConfig = {
          After = "network-online.target";
        };
      };

      services."tldr-update" = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe cfg.package} --update";
        };
      };
    };
  };
}
