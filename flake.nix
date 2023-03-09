{
  description = "d12bb's dotfiles";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    rust-overlay,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.alejandra
            pkgs.nil
          ];
        };
        formatter = pkgs.alejandra;
      }
    )
    // {
      darwinConfigurations."Benedikts-MBP" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./macos.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "bak";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bene = import ./home-manager.nix;
          }
          ({
            config,
            lib,
            modulesPath,
            options,
            pkgs,
            specialArgs,
          }: {
            nixpkgs.overlays = [rust-overlay.overlays.default];
            environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
          })
        ];
      };
    };
}
