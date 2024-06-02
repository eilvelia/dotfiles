{
  description = "Nix configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... } @ inputs:
    let
      homeForSystem = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          inherit inputs;
        };
        modules = [ ./home ];
      };
    in {
      # sudo nixos-rebuild switch --flake .#nixos-vbox
      nixosConfigurations."nixos-vbox" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/vbox ];
      };

      nixosConfigurations."nixos-qemu-aarch64" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/qemu-aarch64 ];
      };

      nixosConfigurations."nixpi" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/nixpi ];
      };

      images."nixpi" = (nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./hosts/nixpi
          {
            config.sdImage.compressImage = nixpkgs.lib.mkForce false;
            config.documentation.enable = false;
          }
        ];
      }).config.system.build.sdImage;

      # home-manager switch --flake .#lambda
      homeConfigurations."lambda@nixos-vbox" = homeForSystem "x86_64-linux";
      homeConfigurations."lambda@nixpi" = homeForSystem "aarch64-linux";
      homeConfigurations."lambda-macos" = homeForSystem "x86_64-darwin";
    };
}
