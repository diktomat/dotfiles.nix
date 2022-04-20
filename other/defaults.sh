#!/bin/sh

# Expanded save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Keyboard control for buttons, modal dialogs etc
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Screenshots on Desktop as PNG without shadow
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# Finder:
#	Show hidden files and all extensions
#	No warning when changing extension
#	Column view by default
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.Finder FXPreferredViewStyle clmv

# Dock: Auto-hide with no delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0

# TextEdit: Plain Text as default
defaults write com.apple.TextEdit RichText -int 0

