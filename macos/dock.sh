#!/usr/bin/env bash

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Mimestream.app"
dockutil --no-restart --add "/Applications/Microsoft Outlook.app"
dockutil --no-restart --add "/Applications/Cron.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/System/Applications/System Preferences.app"
[ -d "$DOTFILES_DIR" ] && dockutil --no-restart --add "$DOTFILES_DIR" --view grid --display folder --sort kind
[ -d "$HOME/Drive" ] && dockutil --no-restart --add "$HOME/Drive" --view grid --display folder --sort kind
dockutil --no-restart --add "/Applications" --view grid --display folder --sort name

killall Dock