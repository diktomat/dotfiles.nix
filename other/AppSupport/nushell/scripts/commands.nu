# Interactive Ripgrep
def frg [] {
	(rg -i -l --color always --files
		|fzf --bind "change:reload:rg -i -l --color always {q}"
			--preview "rg -i --pretty --context 2 {q} {}"
			--disabled)
}


# Interactively install software using Homebrew
def fbi [query: string = ""] {
	let preview = 'HOMEBREW_COLOR=1 brew info {}'
	let pkgs = (brew formulae |lines |append (brew casks |sed 's|^|homebrew/cask/|')
		|to text
		|fzf --multi --preview $preview --query $query --nth=-1 --with-nth=-2.. --delimiter=/
		|str replace -a "\n" " ")

	if $pkgs != "" {
		brew install $pkgs
	} else {
		print "Nothing to install…"
	}
}

# Update Homebrew
def brup [] {
	brew update out+err> /dev/null
	brew outdated
	echo
	let confirm = (input "Upgrade now? [Y/n] ")
	echo
	if $confirm == y || $confirm == Y || $confirm == "" {
		brew upgrade --fetch-HEAD
	}
}

# Edit a file in existing Neovide
def e [...argv: any] {
	# TODO: --remote-{tab,send,expr}
	# TODO: allow passing flags
	let sock = $"($env.XDG_RUNTIME_DIR)/nvim.sock"
	if (path-exists $sock) {
		nvim --server $sock --remote $argv
	} else {
		neovide --multigrid -- --listen $sock $argv
	}
}

# CD to a newly created directory
def-env mcd [path: string] {
	mkdir $path
	cd $path
}
