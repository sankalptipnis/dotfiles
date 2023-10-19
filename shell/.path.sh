#!/usr/bin/env bash

# Add /usr/local/bin
prepend-path "/usr/local/bin"

# Add Homebrew installed binaries
eval "$("$HOMEBREW_PREFIX"/bin/brew shellenv)"

# Add GNU utils
for d in "$HOMEBREW_PREFIX"/opt/*/libexec/gnubin; do prepend-path "$d"; done

# Make own utilities available
prepend-path "$DOTFILES_DIR/bin"

# Add Haskell related binaries
prepend-path "$HOME/.ghcup/bin"

# Remove duplicates
# Source: http://unix.stackexchange.com/a/40755
PATH=$(echo -n "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')

export PATH