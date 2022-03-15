#!/usr/bin/env bash

# Define dotfiles directory
export DOTFILES_DIR="$HOME/dotfiles"

# Initialize shell
[[ -r "$DOTFILES_DIR/shell/.init.sh" ]] && source "$DOTFILES_DIR/shell/.init.sh"

# Load the prompt
[[ -r "$DOTFILES_DIR/bash/.bash_prompt.bash" ]] && source "$DOTFILES_DIR/bash/.bash_prompt.bash"

# Load history settings
[[ -r "$DOTFILES_DIR/bash/.bash_hist.bash" ]] && source "$DOTFILES_DIR/bash/.bash_hist.bash"

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

# Initialize Zoxide 
eval "$(zoxide init bash)"

# Initialze fzf
_fzf_script="$DOTFILES_DIR/fzf/.fzf.bash"
[[ -r "$_fzf_script" ]] && source "$_fzf_script"

# Initialize fzf-obc 
_fzf_obc_script="$DOTFILES_DIR/submodules/fzf-obc/bin/fzf-obc.bash"
[[ -r "$_fzf_obc_script" ]] && source "$_fzf_obc_script"