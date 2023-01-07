# XDG Base Directory Specification
# https://wiki.archlinux.org/title/XDG_Base_Directory#Support
# set here instead of universal because $HOME would else be stored extended
if test (uname -s) = Darwin
	set -gx XDG_CACHE_HOME  $HOME/Library/Caches
else
	set -gx XDG_CACHE_HOME $HOME/.cache
end
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME   $HOME/.local/share
set -gx XDG_STATE_HOME  $HOME/.local/state
set -gx XDG_RUNTIME_DIR $HOME/.local/run
#	Bundler
set -gx BUNDLE_USER_CONFIG $XDG_CONFIG_HOME/bundle
set -gx BUNDLE_USER_CACHE  $XDG_CACHE_HOME/bundle
set -gx BUNDLE_USER_PLUGIN $XDG_DATA_HOME/bundle
#	Go
set -gx GOPATH $XDG_DATA_HOME/go
#	Ripgrep
set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgreprc
#	Rust
set -gx CARGO_HOME  $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx RUST_BACKTRACE 1

# Less
set -gx LESS "--ignore-case --incsearch --HILITE-UNREAD --tabs=4 --prompt='?n?f%f.:?e?x Next\: %x:(EOF).:?p%pb\%...?m (%i/%m).'"
set -gx LESSHISTFILE /dev/null

# Man with bat
# set -gx MANPAGER "nvim +Man!"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# PATH
fish_add_path -g $GOPATH/bin
fish_add_path -g $CARGO_HOME/bin
fish_add_path -g $HOME/.local/bin
