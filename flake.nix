# To get started:
#	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
#	nix build .#darwinConfigurations.Benedikts-MBP.system
#	./result/sw/bin/darwin-rebuild switch --flake .#Benedikts-MBP

{
	description = "d12bb's dotfiles";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		darwin = {
			url = "github:lnl7/nix-darwin/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{self, darwin, home-manager, nixpkgs, ...}: {
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
			];
		};
	};
}
