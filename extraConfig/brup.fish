brew update &> /dev/null
set outdated (brew outdated --verbose)
if test -z "$outdated"
	echo Nothing to upgrade..
else
	for line in $outdated
		echo $line
	end
	echo
	read -f -P "Upgrade now? [Y/n] " confirm
	echo
	switch $confirm
	case Y y ''
		brew upgrade --fetch-HEAD
	end
end
