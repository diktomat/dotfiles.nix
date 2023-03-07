# d12bb's dotfiles

This is my whole system configuration, at least the bulk of it. It's a living,
breathing document on how I like my system to be, how I like to work. The whole
thing is one Nix flake, so getting a new machine up and running is just a
matter of minutes to get exactly the environment I want, including packages and
configuration.

Currently, it's monolithic and only for Darwin machines, but the next time I get
to set up a new Linux machine, I'll probably use NixOS and refactor this repo
to be used for both systems.

This README aims to both introduce this repo to you, the gentle reader, who
might want to be inspired by it, and myself, to remind future me on how this
works.

## Structure

- `flake.nix`: The main file, putting it all together
- `macos.nix`: Everything Darwin related
	- Brew casks
	- System settings
- `home-manager.nix`: Everything `$HOME`
	- Packages
	- Configuration
- `extraConfig/`: Configuration files to big for inlining
- everything else: Remnants of my old self

## Bootstrap

```fish
### Darwin
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# Build and use flake
nix build .#darwinConfigurations.Benedikts-MBP.system
./result/sw/bin/darwin-rebuild switch --flake .#Benedikts-MBP
# Change shell
chsh -s /path/to/nix/fish
```

## Usage
### Update software

```fish
nix flake update

# Update immediately:
darwin-rebuild switch --flake .#Benedikts-MBP

# Or review updates first:
darwin-rebuild build --flake .#Benedikts-MBP
nix store diff-closures /nix/var/nix/profiles/system ./result
./result/activate
```

### Bring changes live

```fish
darwin-rebuild switch --flake .#Benedikts-MBP
```

## TODO

- [ ] Rust
- [ ] Use devenv? devshell? direnv? wtf?
- [ ] Think on how to integrate gui tools
- [x] README

## Thanks

- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
- [Homebrew](https://brew.sh)
- and the developers of all those tools I use every day!

## UNLICENSE

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
