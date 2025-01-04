{ config, pkgs, lib, link, dotfiles, ... }:
{
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    goku
    htop
    neofetch
    pstree

    hlesspass
    katahexCPU
    katahex19CPU
  ];

  home.file = {
    ".inputrc".source = link "${dotfiles}/inputrc";
    ".vimrc".source = link "${dotfiles}/vimrc";
  };

  launchd.agents.homebrew-update = {
    enable = true;
    config.ProgramArguments = [
      "/usr/bin/env"
      "brew"
      "update"
    ];
    config.StartCalendarInterval = [{ Minute = 0; Hour = 13; }];
    config.StandardOutPath = "/tmp/auto-run-update.log";
    config.StandardErrorPath = "/tmp/auto-run-update.log";
    config.EnvironmentVariables.PATH =
      "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
  };

  launchd.agents.tldr-update = {
    enable = true;
    config.ProgramArguments = [
      "${pkgs.tldr}/bin/tldr"
      "--update"
    ];
    config.StartCalendarInterval = [{ Minute = 0; Hour = 14; Weekday = 6; }];
    config.StandardOutPath = "/tmp/auto-run-update.log";
    config.StandardErrorPath = "/tmp/auto-run-update.log";
    config.EnvironmentVariables.NIX_SSL_CERT_FILE =
      "/etc/ssl/certs/ca-certificates.crt";
  };

  launchd.agents.opam-update = {
    enable = true;
    config.ProgramArguments = [
      "${pkgs.unstable.opam}/bin/opam"
      "update"
    ];
    config.StartCalendarInterval = [{ Minute = 0; Hour = 14; Weekday = 0; }];
    config.StandardOutPath = "/tmp/auto-run-update.log";
    config.StandardErrorPath = "/tmp/auto-run-update.log";
    config.EnvironmentVariables.PATH =
      "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
  };
}
