{ fetchFromGitHub, haskell, haskellPackages }:
let
  inherit (haskell.lib.compose) justStaticExecutables;
  pkg = haskellPackages.callPackage (
    { mkDerivation, base, bytestring, cmdargs, crypton, directory
    , hspec, lib, memory, process, unix, xdg-basedir, filepath, text
    }:
    mkDerivation rec {
      pname = "hlesspass";
      version = "0.2.0";

      src = fetchFromGitHub {
        owner = "eilvelia";
        repo = "hlesspass";
        rev = "8e5a82ec7a2c074ce67292bec91820e6065a3a85";
        hash = "sha256-seJmfmoShwUmf4Y3ODcL8/Y5HDUC6psvmL53IgL7VmM=";
      };

      isLibrary = false;
      isExecutable = true;

      libraryHaskellDepends = [ base bytestring memory crypton text ];
      executableHaskellDepends = libraryHaskellDepends
        ++ [ cmdargs directory process unix xdg-basedir filepath ];
      testHaskellDepends = libraryHaskellDepends
        ++ [ hspec ];

      description = "Alternative CLI application for LessPass";
      mainProgram = "hlesspass";
      homepage = "https://github.com/eilvelia/hlesspass";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = [ ];
    }) {};
in
justStaticExecutables pkg
