{
  description = "Nix configuration flake";

  inputs = {
    # currently uses unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin-home-manager.url = "github:nix-community/home-manager/master";
    darwin-home-manager.inputs.nixpkgs.follows = "darwin-nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "darwin-nixpkgs";
  };

  outputs = { nixpkgs, nix-darwin, ... } @ inputs:
    let
      mkUnstableOverlay = pkgs: final: _prev: {
        unstable = pkgs.legacyPackages.${final.system};
      };
      # standalone home for darwin
      mkDarwinHome = arch:
        let
          system = arch + "-darwin";
          inherit (inputs) darwin-nixpkgs darwin-home-manager;
        in
        darwin-home-manager.lib.homeManagerConfiguration {
          pkgs = darwin-nixpkgs.legacyPackages.${system};
          modules = [
            # on macOS, there's no difference between "nixpkgs" and "unstable"
            { nixpkgs.overlays = [ (mkUnstableOverlay darwin-nixpkgs) ]; }
            ./home/darwin.nix
          ];
        };
      # standalone home for linux
      mkLinuxHome = arch:
        let
          system = arch + "-linux";
          inherit (inputs) nixpkgs-unstable home-manager;
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            { nixpkgs.overlays = [ (mkUnstableOverlay nixpkgs-unstable) ]; }
            ./home/linux.nix
          ];
        };
      nixosBaseModule = {
        nix.registry.unstable.flake = inputs.nixpkgs-unstable;
        nixpkgs.overlays = [ (mkUnstableOverlay inputs.nixpkgs-unstable) ];
      };
      specialArgs = { inherit (inputs) home-manager nixos-hardware; };
      darwinBaseModule = {
        nix.registry.nixpkgs.flake = inputs.darwin-nixpkgs;
        nix.registry.unstable.flake = inputs.darwin-nixpkgs;
        nix.settings.nix-path = [
          "nixpkgs=${inputs.darwin-nixpkgs}"
          "unstable=${inputs.darwin-nixpkgs}"
        ];
        nixpkgs.overlays = [ (mkUnstableOverlay inputs.darwin-nixpkgs) ];
      };
    in {
      # nixos-rebuild switch --use-remote-sudo --flake .
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
      homeConfigurations."lambda@nixpi" = mkLinuxHome "aarch64";
      homeConfigurations."lambda@MacBook-Pro.local" = mkDarwinHome "x86_64";

      # darwin-rebuild switch --flake .
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [ darwinBaseModule ./darwin ];
      };

      # the custom packages can potentially be used outside
      overlays.default = (import ./overlays).default;
    };
}
