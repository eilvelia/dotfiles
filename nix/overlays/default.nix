final: prev:
let
  inherit (final) pkgs;
in
{
  zf = pkgs.callPackage ./zf { };
}
