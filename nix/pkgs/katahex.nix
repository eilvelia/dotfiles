# Based on https://github.com/NixOS/nixpkgs/blob/bf2cebf539a601f0c191efca007b493d5b0b6de2/pkgs/games/katago/default.nix
{ stdenv, boost, cmake, config, cudaPackages, eigen, fetchFromGitHub
, lib, libzip, makeWrapper, ocl-icd, opencl-headers
, enableAVX2 ? stdenv.hostPlatform.avx2Support
, backend ? if config.cudaSupport then "cuda" else "opencl"
, maxBoardSize ? 14
, binaryName ? "katahex" }:

assert lib.assertOneOf "backend" backend [ "opencl" "cuda" "tensorrt" "eigen" ];

stdenv.mkDerivation {
  pname = "katahex";
  version = "2024-08-13";

  src = fetchFromGitHub {
    owner = "hzyhhzy";
    repo = "KataGo";
    rev = "eafb7ae7effb959c7419a662bd74a03d60820d71"; # Hex2024
    hash = "sha256-stzNnCT2fe5aEid4Ry2/7ysjnSw9OhdIEaCFG9UlXTg=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];

  buildInputs = [ libzip boost ]
    ++ lib.optionals (backend == "eigen") [ eigen ]
    ++ lib.optionals (backend == "cuda") [
      cudaPackages.cudnn
      cudaPackages.cudatoolkit
    ] ++ lib.optionals (backend == "tensorrt") [
      cudaPackages.cudatoolkit
      cudaPackages.tensorrt
    ] ++ lib.optionals (backend == "opencl") [ opencl-headers ocl-icd ];

  cmakeFlags = [
    # Note: Enabling USE_TCMALLOC seems to segfault (at least on macOS)
    (lib.cmakeFeature "USE_BACKEND" (lib.toUpper backend))
    (lib.cmakeBool "USE_AVX2" enableAVX2)
    (lib.cmakeBool "NO_GIT_REVISION" true)
  ];

  postPatch = ''
    echo "target_compile_definitions(katago PRIVATE COMPILE_MAX_BOARD_LEN=${builtins.toString maxBoardSize})" \
      >> cpp/CMakeLists.txt
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace cpp/CMakeLists.txt \
      --replace 'target_link_libraries(katago "atomic")' ""
  '';

  preConfigure = ''
    cd cpp/
  '' + lib.optionalString (backend == "cuda" || backend == "tensorrt") ''
    export CUDA_PATH="${cudaPackages.cudatoolkit}"
    export EXTRA_LDFLAGS="-L/run/opengl-driver/lib"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin; cp katago $out/bin/${binaryName};
  '' + lib.optionalString (backend == "cuda" || backend == "tensorrt") ''
    wrapProgram $out/bin/${binaryName} \
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  '' + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "Hex engine forked from KataGo";
    mainProgram = binaryName;
    homepage = "https://github.com/hzyhhzy/KataGo/tree/Hex2024";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
