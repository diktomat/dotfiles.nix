#!/bin/sh

if test -d $XDG_CONFIG_HOME; then
	CONFIG=$XDG_CONFIG_HOME
else
	CONFIG=$HOME/.config
fi

HOMESRC=$CONFIG/other/home
for file in $HOMESRC/*; do
	dest=.$(basename $file)
	if test -e $HOME/$dest; then
		echo $dest already exists
		errors="$errors\n$dest already exists"
	else
		echo "Linking $file..."
		ln -s "$file" "$HOME/$dest"
	fi
done

echo Bundleing brew...
brew bundle --file $CONFIG/other/Brewfile
if $? -ne 0; then
	errors="$errors\nBrew bundle failed"
fi

if test "$errors"; then
	echo
	echo There were errors:
	echo $errors
else
	echo All done!
fi
