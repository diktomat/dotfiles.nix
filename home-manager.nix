{ config, pkgs, ...}:
{
	home.stateVersion = "22.11";
	programs = {
		fish.enable = true;
	};
	home.packages = [ ];
}
