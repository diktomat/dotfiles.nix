test -d /opt/homebrew && eval (/opt/homebrew/bin/brew shellenv)

# if status is-login
#	Commands to run in login sessions can go here
# end

if status is-interactive
	which -s starship && starship init fish |source
	which -s zoxide   && zoxide init fish   |source
end

set -x EDITOR vim
which -s nvim && set -x EDITOR nvim
which -s bat  && abbr -g cat bat
abbr -g cdtmp 'cd (mktemp -d)'
abbr -g lg 'lazygit'
if which -s lsd
	abbr -g ls    'lsd'
	abbr -g l     'lsd -l'
	abbr -g la    'lsd -lA'
	abbr -g tree  'lsd --tree'
end
if which -s kitty
	abbr -g icat  'kitty +kitten icat'
	abbr -g kdiff 'kitty +kitten diff'
    abbr -g ssh   'kitty +kitten ssh'
	function krg --wraps rg; kitty +kitten hyperlinked_grep $argv; end
end

# Auth sudo with Touch ID
# Gets deleted with every system update or so
if test (uname) = Darwin && not grep pam_tid /etc/pam.d/sudo > /dev/null 2>&1
	echo 'Adding Touch ID to sudo again...'
	echo "sudo sed -i '.bak' '/sufficient/p; s/smartcard/tid/' /etc/pam.d/sudo"
	sudo sed -i '.bak' '/sufficient/p; s/smartcard/tid/' /etc/pam.d/sudo
end

# FZF Config
set -gx FZF_DEFAULT_COMMAND "fd --hidden --color always"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND --search-path \$dir"
set -gx FZF_ALT_C_COMMAND "$FZF_DEFAULT_COMMAND --type directory"
set -gx FZF_DEFAULT_OPTS "--ansi --tabstop=4 --preview='bat -p --color=always {}' --info=inline --tiebreak=length"
set -gx FZF_CTRL_R_OPTS "--preview 'echo {} |bat -l fish -p --color=always' --preview-window=down:3:wrap --reverse"
set -gx FZF_ALT_C_OPTS "--preview 'lsd --color always --icon always {}'"
