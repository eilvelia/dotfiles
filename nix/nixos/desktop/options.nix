{ pkgs, lib, ... }:
{
  options.custom = {
    enableCustomPackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    defaultFont = lib.mkOption {
      type = lib.types.str;
      default = "Roboto";
    };
  };
}
