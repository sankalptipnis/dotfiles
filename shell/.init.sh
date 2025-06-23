#!/usr/bin/env bash

# Get Homebrew prefix
if [[ "$(uname -m)" == "arm64" ]]; then 
	HOMEBREW_PREFIX=/opt/homebrew
else
	HOMEBREW_PREFIX=/usr/local
fi

# Load exports, aliases, functions, and PATH
for file in "$DOTFILES_DIR"/shell/.{colors,exports,aliases,functions,path}.sh; do
	[[ -r "$file" ]] && source "$file"
done
unset file

# Load LS_COLORS
if is-executable -q dircolors; then
	[[ -r "$DOTFILES_DIR/shell/.dircolors.sh" ]] && eval "$(dircolors "$DOTFILES_DIR/shell/.dircolors.sh")"
fi

# Initialize conda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
