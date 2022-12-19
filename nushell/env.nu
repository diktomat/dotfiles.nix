# $PATH conversion
let-env PATH = ($env.PATH |split row (char esep))
let-env ENV_CONVERSIONS = {
	"PATH": {
		from_string: { |s| $s |split row (char esep) |path expand -n }
		to_string:   { |v| $v |path expand -n |str join (char esep)  }
	}
	"MANPATH": {
		from_string: { |s| $s |split row (char esep) |path expand -n }
		to_string:   { |v| $v |path expand -n |str join (char esep)  }
	}
}

let-env NU_LIB_DIRS = [
	($nu.config-path |path dirname)
	($nu.config-path |path dirname |path join 'scripts')
]
let-env NU_PLUGIN_DIRS = [
	($nu.config-path |path dirname |path join 'plugins')
]

let-env LANG = "en_US.UTF-8"

# XDG Base Directory Specification
let-env XDG_CACHE_HOME  = $"($env.HOME)/(if $nu.os-info.name == macos {'Library/Caches'} else {'.cache'})"
let-env XDG_CONFIG_HOME = $"($env.HOME)/.config"
let-env XDG_DATA_HOME   = $"($env.HOME)/.local/share"
let-env XDG_RUNTIME_DIR = $"($env.HOME)/.local/run"
let-env XDG_STATE_HOME  = $"($env.HOME)/.local/state"

# Ripgrep
let-env RIPGREP_CONFIG_PATH = $"($env.XDG_CONFIG_HOME)/ripgreprc"

# Homebrew
let-env HOMEBREW_PREFIX     = "/opt/homebrew"
let-env HOMEBREW_CELLAR     = $"($env.HOMEBREW_PREFIX)/Cellar"
let-env HOMEBREW_REPOSITORY = $env.HOMEBREW_PREFIX
let-env PATH                = ($env.PATH    |prepend $"($env.HOMEBREW_PREFIX)/lib/ruby/gems/3.1.0/bin")
let-env PATH                = ($env.PATH    |prepend $"($env.HOMEBREW_PREFIX)/opt/ruby/bin")
let-env PATH                = ($env.PATH    |prepend $"($env.HOMEBREW_PREFIX)/bin")
let-env PATH                = ($env.PATH    |prepend $"($env.HOMEBREW_PREFIX)/sbin")
let-env MANPATH             = ($env.MANPATH |prepend $"($env.HOMEBREW_PREFIX)/share/man")

# Bundler
let-env BUNDLE_USER_CACHE  = $"($env.XDG_CACHE_HOME)/bundle"
let-env BUNDLE_USER_CONFIG = $"($env.XDG_CONFIG_HOME)/bundle"
let-env BUNDLE_USER_PLUGIN = $"($env.XDG_DATA_HOME)/bundle"

# Go
let-env GOPATH = $"($env.XDG_DATA_HOME)/go"
let-env PATH   = ($env.PATH |prepend $"($env.GOPATH)/bin")

# Rust
let-env RUSTUP_HOME = $"($env.XDG_DATA_HOME)/rustup"
let-env CARGO_HOME  = $"($env.XDG_DATA_HOME)/cargo"
let-env PATH        = ($env.PATH |prepend $"($env.CARGO_HOME)/bin")

# Paths
let-env PATH    = ($env.PATH    |prepend $"($env.HOME)/.local/bin")
let-env MANPATH = ($env.MANPATH |append [
	"/usr/share/man"
	"/usr/local/share/man"
	"/usr/local/MacGPG2/share/man"
	"/Library/TeX/Distributions/.DefaultTeX/Contents/Man"
	"/Applications/kitty.app/Contents/Resources/man"
])

starship init nu    |save $"($nu.config-path |path dirname)/starship.nu"
zoxide init nushell |save $"($nu.config-path |path dirname)/zoxide.nu"
