#!/usr/bin/env bash

# Get Homebrew prefix
if [[ "$(uname -m)" == "arm64" ]]; then 
	HOMEBREW_PREFIX=/opt/homebrew
else
	HOMEBREW_PREFIX=/usr/local
fi

# Define dotfiles directory
export DOTFILES_DIR="$HOME/dotfiles"

# Load the shell dotfiles, and then some:
for file in $DOTFILES_DIR/bash_helpers/.{prompt,exports,history,aliases,functions,path}; do
	[ -r "$file" ] && source "$file"
done
unset file

if is-executable dircolors; then
	[ -r $DOTFILES_DIR/bash_helpers/.dircolors ] && eval "$(dircolors $DOTFILES_DIR/bash_helpers/.dircolors)"
fi

# Add tab completion for Bash commands
[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ] && source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -r "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Initialize conda
_conda_script="${HOMEBREW_PREFIX}/Caskroom/miniforge/base/etc/profile.d/conda.sh"
[ -r $_conda_script ] && source $_conda_script

# Add global ROOT to PYTHONPATH so it is accessible from conda envs
prefix=".."
suffix="/bin/root"
ROOT_LIB_DIR=$(readlink $(which root))
ROOT_LIB_DIR=${ROOT_LIB_DIR#"$prefix"}
ROOT_LIB_DIR=${ROOT_LIB_DIR%"$suffix"}
ROOT_LIB_DIR="${HOMEBREW_PREFIX}${ROOT_LIB_DIR}/lib/root"
PYTHONPATH="$ROOT_LIB_DIR:$PYTHONPATH"
PYTHONPATH=${PYTHONPATH%":"}
PYTHONPATH=$(echo -n $PYTHONPATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')
[ -d $ROOT_LIB_DIR ] && export PYTHONPATH

# Initilize fzf-obc
[ -r "$DOTFILES_DIR/fzf-obc/bin/fzf-obc.bash" ] && source "$DOTFILES_DIR/fzf-obc/bin/fzf-obc.bash"