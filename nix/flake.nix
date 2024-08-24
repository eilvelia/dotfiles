{
  description = "Nix configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin-home-manager.url = "github:nix-community/home-manager/master";
    darwin-home-manager.inputs.nixpkgs.follows = "darwin-nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "darwin-nixpkgs";
  };

  outputs = { nixpkgs, nix-darwin, ... } @ inputs:
    let
      overlays = import ./overlays;
      homeForSystem = system:
        let
          isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
          nixp = if isDarwin then inputs.darwin-nixpkgs else nixpkgs;
          # on macos, "unstable" is the same as "nixpkgs"
          nixp-unstable = if isDarwin then nixp else inputs.nixpkgs-unstable;
          home-manager = if isDarwin
            then inputs.darwin-home-manager
            else inputs.home-manager;
          unstableOverlay = final: _prev: {
            unstable = nixp-unstable.legacyPackages.${final.system};
          };
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixp.legacyPackages.${system};
          modules = [
            {
              nixpkgs.overlays = [ unstableOverlay overlays.default ];
            }
            ./home
          ];
        };
      nixosUnstableOverlay = final: _prev: {
        unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
      };
      nixosBaseModule = {
        nix.registry.unstable.flake = inputs.nixpkgs-unstable;
        nixpkgs.overlays = [ nixosUnstableOverlay overlays.default ];
      };
      darwinUnstableOverlay = final: _prev: {
        unstable = inputs.darwin-nixpkgs.legacyPackages.${final.system};
      };
      darwinBaseModule = {
        nix.registry.nixpkgs.flake = inputs.darwin-nixpkgs;
        nix.registry.unstable.flake = inputs.darwin-nixpkgs;
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nix.settings.nix-path = [
          "nixpkgs=${inputs.darwin-nixpkgs}"
          "unstable=${inputs.darwin-nixpkgs}"
        ];
        nixpkgs.overlays = [ darwinUnstableOverlay overlays.default ];
      };
    in {
      # nixos-rebuild switch --use-remote-sudo --flake .
      nixosConfigurations."nixos-vbox" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/vbox ];
      };

      nixosConfigurations."nixos-vmware" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/vmware ];
      };

      nixosConfigurations."nixos-parallels" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/parallels ];
      };

      nixosConfigurations."nixos-qemu-aarch64" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/qemu-aarch64 ];
      };

      nixosConfigurations."nixpi" = nixpkgs.lib.nixosSystem {
        modules = [ nixosBaseModule ./hosts/nixpi ];
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
      homeConfigurations."lambda@nixos-parallels" = homeForSystem "x86_64-linux";
      homeConfigurations."lambda@nixpi" = homeForSystem "aarch64-linux";
      homeConfigurations."lambda@MacBook-Pro.local" = homeForSystem "x86_64-darwin";

      # darwin-rebuild switch --flake .
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [ darwinBaseModule ./darwin ];
      };
    };
}
