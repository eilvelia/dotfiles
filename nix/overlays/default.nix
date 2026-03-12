{
  default = final: prev: let
    pkgs = final;
  in rec {
    katahex = pkgs.callPackage ../pkgs/katahex.nix { };
    katahex19 = katahex.override {
      maxBoardSize = 19;
      executableName = "katahex-19";
    };
    katahexCPU = katahex.override { backend = "eigen"; };
    katahexCPUAVX2 = katahex.override { backend = "eigen"; enableAVX2 = true; };
    katahex19CPU = katahex19.override { backend = "eigen"; };
    katahex19CPUAVX2 = katahex19.override { backend = "eigen"; enableAVX2 = true; };

    hlesspass = pkgs.callPackage ../pkgs/hlesspass.nix { };

    anyrun = pkgs.callPackage ../pkgs/anyrun.nix { };
  };
}
