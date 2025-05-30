{ config, pkgs, lib, ... }:
{
  imports = [
    ../generic.nix
  ];

  environment.systemPackages = with pkgs; [
    stdenv.cc
  ];

  networking.networkmanager.plugins = lib.mkForce [];

  security.pam.sshAgentAuth.enable = true;

  services.soju = {
    enable = true;
    hostName = "${config.networking.hostName}.lan";
    tlsCertificate = "/var/lib/private/soju/cert.pem";
    tlsCertificateKey = "/var/lib/private/soju/key.pem";
    enableMessageLogging = false;
    # extraConfig = ''
    #   message-store db /var/lib/soju/messages.db
    # '';
  };

  systemd.services.soju.unitConfig = {
    ConditionPathExists = "/var/lib/private/soju/cert.pem";
  };

  # services.tor = {
  #   enable = true;
  #   client.enable = true;
  # };
}
