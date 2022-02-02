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
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in $DOTFILES_DIR/bash_helpers/.{prompt,exports,aliases,functions,path}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

if is-executable dircolors; then
	[ -r $DOTFILES_DIR/bash_helpers/.dircolors ] && eval "$(dircolors $DOTFILES_DIR/bash_helpers/.dircolors)"
fi

# Add tab completion for Bash commands
if is-executable brew && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif [ -r /etc/bash_completion ]; then
	source /etc/bash_completion
fi

# Add tab completion for Git
if is-executable brew && [ -r "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
    source "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
fi

# Add all other completions
# if is-executable brew && [ -d "$(brew --prefix)/etc/bash_completion.d" ]; then
#   for file in "$(brew --prefix)/etc/bash_completion.d"/*; do
#     source $file
#   done
# fi

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($(brew --prefix)/Caskroom/miniforge/base/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$(brew --prefix)/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "$(brew --prefix)/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="$(brew --prefix)/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Add global ROOT to PYTHONPATH so it is accessible from conda envs
prefix=".."
suffix="/bin/root"
ROOT_LIB_DIR=$(readlink $(which root))
ROOT_LIB_DIR=${ROOT_LIB_DIR#"$prefix"}
ROOT_LIB_DIR=${ROOT_LIB_DIR%"$suffix"}
ROOT_LIB_DIR="$(brew --prefix)${ROOT_LIB_DIR}/lib/root"
PYTHONPATH="$ROOT_LIB_DIR:$PYTHONPATH"
PYTHONPATH=${PYTHONPATH%":"}
[ -d $ROOT_LIB_DIR ] && export PYTHONPATH

