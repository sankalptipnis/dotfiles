#!/usr/bin/env bash

INSTALL_DIR="$HOME/Desktop"
FILENAME="dockutil-3.0.2.pkg"
delete "$INSTALL_DIR/$FILENAME"
wget -P "$HOME/Desktop" "https://github.com/kcrawford/dockutil/releases/download/3.0.2/$FILENAME"
sudo installer -pkg "$INSTALL_DIR/$FILENAME" -target /
delete "$INSTALL_DIR/$FILENAME"