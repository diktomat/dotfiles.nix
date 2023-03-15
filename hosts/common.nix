{...}: {
  nix = {
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-nix-path = nixpkgs=flake:nixpkgs
    '';
  };
}
