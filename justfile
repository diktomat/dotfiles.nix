default:
	@just --list

flakedir := justfile_directory()
rebuild := if os() == "macos" { "darwin-rebuild" } else { "sudo nixos-rebuild" }

build host=`uname -n`:
	{{rebuild}} build --flake {{flakedir}}#{{host}}

switch host=`uname -n`:
	{{rebuild}} switch --flake {{flakedir}}#{{host}}

update:
	nix flake update

diff: build
	nvd diff /run/current-system result
