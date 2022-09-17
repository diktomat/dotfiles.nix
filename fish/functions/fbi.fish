function fbi -a query -d 'Install Brew package via FZF'
	set -f PREVIEW 'HOMEBREW_COLOR=1 brew info {}'
	set -f PKGS (brew formulae) (brew casks)
	set -f INSTALL_PKGS (echo $PKGS |sed 's/ /\n/g' |fzf -m --preview=$PREVIEW --query=$query --tiebreak=length)
	if test ! -z "$INSTALL_PKGS"
		brew install $INSTALL_PKGS
	else
		echo "Nothing to install…"
	end
end
