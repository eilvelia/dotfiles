{
  description = "Nix configuration flake";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # home-manager.url = "github:nix-community/home-manager/master";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "darwin-nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware,
              darwin-nixpkgs, nix-darwin, ... } @ inputs:
    let
      nixpkgs-unstable = nixpkgs;
      mkUnstableOverlay = flake: _final: prev: {
        unstable = flake.legacyPackages.${prev.stdenv.hostPlatform.system};
      };
      nixosBaseModule = {
        nixpkgs.overlays = [ (mkUnstableOverlay nixpkgs-unstable) ];
        # Prevent certain flake inputs from getting GC'ed
        system.extraDependencies = [ home-manager.outPath ];
      };
      specialArgs = { inherit home-manager nixos-hardware; };
      darwinBaseModule = {
        nixpkgs.overlays = [ (mkUnstableOverlay darwin-nixpkgs) ];
      };
      # standalone home for linux
      mkLinuxHome = arch:
        let system = arch + "-linux"; in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ nixosBaseModule ./home/extra.nix ];
        };
      # standalone home for darwin
      mkDarwinHome = arch:
        let system = arch + "-darwin"; in
        home-manager.lib.homeManagerConfiguration {
          pkgs = darwin-nixpkgs.legacyPackages.${system};
          modules = [ darwinBaseModule ./darwin/home.nix ];
        };
    in {
      # nixos-rebuild switch --use-remote-sudo --flake .
      nixosConfigurations."thinkowo" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/thinkowo ];
        inherit specialArgs;
      };

      nixosConfigurations."eastretosh" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/eastretosh ];
        inherit specialArgs;
      };

      nixosConfigurations."nixos-vmware" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/nixos-vmware ];
        inherit specialArgs;
      };

      nixosConfigurations."nixpi" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/nixpi ];
        inherit specialArgs;
      };

      images."nixpi" = (nixpkgs.lib.nixosSystem {
        modules = [
          nixosBaseModule
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./hosts/nixpi
          {
            config.sdImage.compressImage = nixpkgs.lib.mkForce false;
            config.documentation.enable = false;
          }
        ];
      }).config.system.build.sdImage;

      # home-manager switch --flake .
      homeConfigurations."lambda@MacBook-Pro.local" = mkDarwinHome "x86_64";

      # darwin-rebuild switch --flake .
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [ darwinBaseModule ./darwin ];
      };

      # the custom packages can potentially be used outside
      overlays.default = (import ./overlays).default;
    };
}
