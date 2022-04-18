# all the env vars to enforce use of XDG dirs
# https://wiki.archlinux.org/title/XDG_Base_Directory#Support

# XDG Base Directory Specification
# set here instead of universal because $HOME would else be stored extended
set -gx XDG_CACHE_HOME  $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME   $HOME/.local/share
set -gx XDG_STATE_HOME  $HOME/.local/state

# asdf version manager
set -gx ASDF_CONFIG_FILE $XDG_CONFIG_HOME/asdf/asdfrc
set -gx ASDF_DATA_DIR    $XDG_DATA_HOME/asdf

# Ripgrep
set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgreprc

# Rust
set -gx CARGO_HOME  $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
