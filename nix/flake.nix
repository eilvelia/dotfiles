{
  description = "Nix configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
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
        modules = [ ./hosts/vbox/configuration.nix ];
      };

      # home-manager switch --flake .#lambda
      homeConfigurations."lambda" = homeForSystem "x86_64-linux";
      homeConfigurations."lambda-macos" = homeForSystem "x86_64-darwin";
    };
}
