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

      # home-manager switch --flake .#lambda
      homeConfigurations."lambda" = homeForSystem "x86_64-linux";
      homeConfigurations."lambda-macos" = homeForSystem "x86_64-darwin";
    };
}
