function fbi -a query -d 'Install Brew package via FZF'
	set -f PREVIEW 'HOMEBREW_COLOR=1 brew info {}'
	set -f PKGS (brew formulae) (brew casks |sed 's|^|homebrew/cask/|')

	set -f INSTALL_PKGS (echo $PKGS \
		|sed 's/ /\n/g' \
		|fzf --multi --preview=$PREVIEW --query=$query --nth=-1 --with-nth=-2.. --delimiter=/)

	if test ! -z "$INSTALL_PKGS"
		brew install $INSTALL_PKGS
	else
		echo "Nothing to install…"
	end
end
