{
  description = "d12bb's dotfiles";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # helix = {
    # url = "github:helix-editor/helix";
    # inputs.nixpkgs.follows = "nixpkgs";
    # };
    # TODO: how to Rust
    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "utils";
    # };
  };

  outputs = {
    nixpkgs,
    darwin,
    # helix,
    home-manager,
    utils,
    ...
  }: let
    hmConfig = {
      home-manager.backupFileExtension = "bak";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    };
  in
    {
      # Thpr: Home Macbook Pro
      darwinConfigurations.thor = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/thor.nix
          home-manager.darwinModules.home-manager
          (hmConfig
            // {
              # home-manager.extraSpecialArgs = {helix = helix;};
              home-manager.users.bene = import ./homes/thor.nix;
            })
          # ({
          #   config,
          #   lib,
          #   modulesPath,
          #   options,
          #   pkgs,
          #   specialArgs,
          # }: {
          #   nixpkgs.overlays = [rust-overlay.overlays.default];
          #   environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
          # })
        ];
      };

      # TODO: fast-lane VM
      # nixosConfigurations.heimdal = nixpkgs.lib.nixosSystem {
      #   system = "aarch64-linux";
      #   modules = [
      #     ./hosts/heimdal.nix
      #     home-manager.nixosModules.home-manager
      #     (hmConfig
      #       // {
      #         home-manager.users.bene = import ./homes/heimdal.nix;
      #       })
      #   ];
      # };

      # Loki: Home Raspberry Pi
      homeConfigurations.loki = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [./homes/loki.nix];
        #   ./hosts/loki.nix
        #   home-manager.nixosModules.home-manager
        #   (hmConfig
        #     // {
        #       home-manager.users.bene = import ./homes/loki.nix;
        #     })
        # ];
      };
    }
    // utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            just
            nil
            nvd
          ];
        };
        formatter = pkgs.alejandra;
      }
    );
}
