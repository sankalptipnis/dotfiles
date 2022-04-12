#!/usr/bin/env bash

if [[ "$(uname -m)" == "arm64" ]]; then 
	HOMEBREW_PREFIX=/opt/homebrew
else
	HOMEBREW_PREFIX=/usr/local
fi

PATH="$HOME/dotfiles/bin:$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

DATE="`date +"%Y-%m-%d"`"
LOG_DIR="$HOME/Borg/Logs"
LOG_NAME="borg.daily-backup.$DATE.log"
mkdir -p "$LOG_DIR"

backup create 2>&1 | ts | tee -a "$LOG_DIR"/"$LOG_NAME"
sleep 3
backup prune 2>&1 | ts | tee -a "$LOG_DIR"/"$LOG_NAME"
[[ $(date +%u) == "3" ]] && sleep 3 && backup check | ts | tee -a "$LOG_DIR"/"$LOG_NAME"