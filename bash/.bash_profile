#!/usr/bin/env bash

# Get Homebrew prefix
if [[ "$(uname -m)" == "arm64" ]]; then 
	HOMEBREW_PREFIX=/opt/homebrew
else
	HOMEBREW_PREFIX=/usr/local
fi

# Define dotfiles directory
export DOTFILES_DIR="$HOME/dotfiles"

# Load the prompt
[[ -r "$DOTFILES_DIR/bash/.bash_prompt.bash" ]] && source "$DOTFILES_DIR/bash/.bash_prompt.bash"

# Load history settings
[[ -r "$DOTFILES_DIR/bash/.bash_hist.bash" ]] && source "$DOTFILES_DIR/bash/.bash_hist.bash"

# Load exports, aliases, functions, and PATH
for file in "$DOTFILES_DIR"/shell/.{exports,aliases,functions,path}.sh; do
	[[ -r "$file" ]] && source "$file"
done
unset file

# Load LS_COLORS
if is-executable -q dircolors; then
	[[ -r "$DOTFILES_DIR/shell/.dircolors.sh" ]] && eval "$(dircolors $DOTFILES_DIR/shell/.dircolors.sh)"
fi

# Add tab completion for Bash commands
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[[ -r "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Patterns which match no files to expand to a null string, 
# rather than themselves (breaks fzf-obc if enabled)
# shopt -s nullglob

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Initialize conda
_conda_script="$HOMEBREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh"
[[ -r "$_conda_script" ]] && source "$_conda_script"

# Set CONDA_BUILD_SYSROOT so that conda installed ROOT works
export CONDA_BUILD_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/

# Initilize fzf-obc
_fzf_script="$DOTFILES_DIR/submodules/fzf-obc/bin/fzf-obc.bash"
[[ -r "$_fzf_script" ]] && source "$_fzf_script"