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
	programs.fish = {
		enable = true;
		useBabelfish = true;
		babelfishPackage = pkgs.babelfish;
	};
	system.defaults = {
		dock.autohide = true;
		dock.autohide-delay = 0.0;
		finder.AppleShowAllExtensions = true;
		finder.AppleShowAllFiles = true;
		finder.FXEnableExtensionChangeWarning = false;
		finder.FXPreferredViewStyle = "clmv"; # column view by default
		finder.ShowPathbar = true;
		finder.ShowStatusBar = true;
		NSGlobalDomain."com.apple.keyboard.fnState" = true; # Fn keys are F1-12
		NSGlobalDomain.AppleKeyboardUIMode = 3; # full keyboard control of dialogs
		NSGlobalDomain.AppleShowAllExtensions = true;
		NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
		NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
		screencapture.disable-shadow = true;
		screencapture.location = "$HOME/Desktop";
		screencapture.type = "png";
	};
	system.defaults.CustomSystemPreferences = {
		"com.apple.TextEdit".RichText = 0;
	};
	system.keyboard.enableKeyMapping = true;
	system.keyboard.remapCapsLockToEscape = true;
	system.stateVersion = 4;
	security.pam.enableSudoTouchIdAuth = true;
	users.users.bene = {
		home = "/Users/bene";
		shell = pkgs.fish;
	};
}
