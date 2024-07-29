{
  description = "Nix configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin-home-manager.url = "github:nix-community/home-manager/release-24.05";
    darwin-home-manager.inputs.nixpkgs.follows = "darwin-nixpkgs";
  };

  outputs = { nixpkgs, ... } @ inputs:
    let
      homeForSystem = system:
        let
          isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
          nixp = if isDarwin then inputs.darwin-nixpkgs else nixpkgs;
          # unstable is the same as nixpkgs on macos
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
          extraSpecialArgs = {
            nixpkgs = nixp;
            nixpkgs-unstable = nixp-unstable;
          };
          modules = [
            {
              nixpkgs.overlays = [ unstableOverlay (import ./overlays) ];
            }
            ./home
          ];
        };
      nixosUnstableOverlay = final: _prev: {
        unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
      };
      baseModule = {
        nix.registry.unstable.flake = inputs.nixpkgs-unstable;
        nixpkgs.overlays = [ nixosUnstableOverlay (import ./overlays) ];
      };
    in {
      # sudo nixos-rebuild switch --flake .#nixos-vbox
      nixosConfigurations."nixos-vbox" = nixpkgs.lib.nixosSystem {
        modules = [ baseModule ./hosts/vbox ];
      };

      nixosConfigurations."nixos-qemu-aarch64" = nixpkgs.lib.nixosSystem {
        modules = [ baseModule ./hosts/qemu-aarch64 ];
      };

      nixosConfigurations."nixpi" = nixpkgs.lib.nixosSystem {
        modules = [ baseModule ./hosts/nixpi ];
      };

      images."nixpi" = (nixpkgs.lib.nixosSystem {
        modules = [
          baseModule
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./hosts/nixpi
          {
            config.sdImage.compressImage = nixpkgs.lib.mkForce false;
            config.documentation.enable = false;
          }
        ];
      }).config.system.build.sdImage;

      # home-manager switch --flake .
      homeConfigurations."lambda@nixos-vbox" = homeForSystem "x86_64-linux";
      homeConfigurations."lambda@nixpi" = homeForSystem "aarch64-linux";
      homeConfigurations."lambda@MacBook-Pro.local" = homeForSystem "x86_64-darwin";
    };
}
