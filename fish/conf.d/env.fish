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
set -gx LESSHISTFILE /dev/null

# Man in nvim
set -gx MANPAGER "nvim +Man!"

# PATH
fish_add_path -g $GOPATH/bin
fish_add_path -g $CARGO_HOME/bin
fish_add_path -g $HOME/.local/bin

# PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/lib/ruby/gems/3.1.0/bin:/opt/homebrew/opt/ruby/bin:/Users/bene/.local/share/go/bin:/Users/bene/.local/share/cargo/bin:/Users/bene/.local/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/usr/local/MacGPG2/bin:/Library/TeX/texbin:/Applications/kitty.app/Contents/MacOS
# MANPATH=/opt/homebrew/share/man:/usr/share/man:/usr/local/share/man:/usr/local/MacGPG2/share/man:/Library/TeX/Distributions/.DefaultTeX/Contents/Man:/Applications/kitty.app/Contents/Resources/man:

