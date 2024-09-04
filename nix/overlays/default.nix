{
  default = final: prev:
    let
      inherit (final) pkgs;
    in rec {
      katahex = pkgs.callPackage ../pkgs/katahex.nix { };
      katahex19 = katahex.override {
        maxBoardSize = 19;
        binaryName = "katahex-19";
      };
      katahexCPU = katahex.override { backend = "eigen"; };
      katahexCPU19 = katahex.override {
        backend = "eigen";
        maxBoardSize = 19;
        binaryName = "katahex-19";
      };

      benzene = pkgs.callPackage ../pkgs/benzene.nix { };
    };
}
