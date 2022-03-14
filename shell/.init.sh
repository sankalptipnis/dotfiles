#!/usr/bin/env bash

# Get Homebrew prefix
if [[ "$(uname -m)" == "arm64" ]]; then 
	HOMEBREW_PREFIX=/opt/homebrew
else
	HOMEBREW_PREFIX=/usr/local
fi

# Load exports, aliases, functions, and PATH
for file in "$DOTFILES_DIR"/shell/.{exports,aliases,functions,path}.sh; do
	[[ -r "$file" ]] && source "$file"
done
unset file

# Load LS_COLORS
if is-executable -q dircolors; then
	[[ -r "$DOTFILES_DIR/shell/.dircolors.sh" ]] && eval "$(dircolors $DOTFILES_DIR/shell/.dircolors.sh)"
fi

# Initialize conda
_conda_script="$HOMEBREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh"
[[ -r "$_conda_script" ]] && source "$_conda_script"

