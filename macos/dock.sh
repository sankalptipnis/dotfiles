#!/usr/bin/env bash

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Mimestream.app"
dockutil --no-restart --add "/Applications/Microsoft Outlook.app"

if (ls /Applications | grep -q "Google Keep.app"); then
    dockutil --no-restart --add "/Applications/Google Keep.app"
fi

dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/System/Applications/App Store.app"
dockutil --no-restart --add "/System/Applications/System Preferences.app"

if [ -d "$HOME/Google Drive" ]; then
    dockutil --no-restart --add "$HOME/Google Drive" --view grid --display folder --sort name
fi

dockutil --no-restart --add "/Applications" --view grid --display folder --sort name

killall Dock