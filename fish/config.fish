eval (/opt/homebrew/bin/brew shellenv)

# if status is-login
#	Commands to run in login sessions can go here
# end

if status is-interactive
	starship init fish |source
	zoxide init fish   |source
end

source (brew --prefix asdf)/libexec/asdf.fish
fish_add_path $CARGO_HOME/bin
fish_add_path $HOME/.local/bin
