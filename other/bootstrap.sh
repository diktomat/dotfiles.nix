#!/bin/sh
# Setup a new system via:
# curl -fsSL github.com/foo/other/bootstrap.sh | sh
# TODO: install XCode CLI Utils, Homebrew, etc
# TODO: maybe even for different OSes? Currently no use for !macOS..

if which brew >/dev/null 2>&1 || test -d /opt/homebrew; then
	echo Found Brew
else
	echo Install Brew
fi

echo Now run install.sh
