function brup
	brew update &> /dev/null
	brew outdated
	echo
	read -f -P "Upgrade now? [Y/n] " confirm
	echo
	switch $confirm
	case Y y ''
		brew upgrade --fetch-HEAD
	end
end
