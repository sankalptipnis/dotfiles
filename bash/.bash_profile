#!/usr/bin/env bash

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
	test -r $DOTFILES_DIR/bash_helpers/.dircolors && eval "$(dircolors $DOTFILES_DIR/bash_helpers/.dircolors)"
fi

# Add tab completion for Bash commands
if is-executable brew && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif [ -r /etc/bash_completion ]; then
	source /etc/bash_completion
fi

# Add tab completion for Git
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
    source "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
fi

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

