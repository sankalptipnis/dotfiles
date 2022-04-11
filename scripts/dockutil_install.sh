#!/usr/bin/env bash

DOWNLOAD_DIR="$HOME/Desktop"
FILENAME="dockutil.pkg"
delete "$DOWNLOAD_DIR/$FILENAME"
URL=$(curl --silent "https://api.github.com/repos/kcrawford/dockutil/releases/latest" | jq -r .assets[].browser_download_url | grep pkg)
curl -sL "$URL" -o "$DOWNLOAD_DIR/$FILENAME"
sudo installer -pkg "$DOWNLOAD_DIR/$FILENAME" -target /
delete "$DOWNLOAD_DIR/$FILENAME"