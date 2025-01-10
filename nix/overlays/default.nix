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

    benzene = prev.benzene.overrideAttrs (prev: {
      postPatch = ''
        # Fixes for boost v1.85.0+
        # https://github.com/cgao3/benzene-vanilla-cmake/issues/18
        substituteInPlace src/util/Misc.cpp \
          --replace-fail '.branch_path()' '.parent_path()' \
          --replace-fail '.normalize()' '.lexically_normal()'
      '' + prev.postPatch;
    });
  };
}
