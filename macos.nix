{
	config,
	pkgs,
	nixpkgs,
	...
}: {
	services.nix-daemon.enable = true;
	nix = {
		package = pkgs.nixUnstable;
		settings.auto-optimise-store = true;
		extraOptions = ''
			experimental-features = nix-command flakes
			extra-nix-path = nixpkgs=flake:nixpkgs
		'';
	};
	programs.fish = {
		enable = true;
		useBabelfish = true;
		babelfishPackage = pkgs.babelfish;
	};
	environment = {
		shells = [pkgs.fish];
		loginShell = pkgs.fish;
	};
	homebrew = {
		enable = true;
		caskArgs.no_quarantine = true;
		global.brewfile = true;
		taps = [];
		brews = [];
		casks = [];
		masApps = {};
		# onActivation.cleanup = "uninstall";
	};
	users.users.bene = {
		home = "/Users/bene";
		shell = pkgs.fish;
	};
	system.stateVersion = 4;
	# security.pam.enableSudoTouchIdAuth = true;
}
