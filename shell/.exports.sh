#!/usr/bin/env bash

# Make Sublime Text the default editor.
export EDITOR='subl'

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr
export PYTHONIOENCODING='UTF-8'

# Don’t clear the screen after quitting a manual page
export MANPAGER='less -X'

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${BOLD}${BRIGHTYELLOW}"

# Silence "default interactive shell is now zsh" warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Highligh Grep matches in bold bright red
export GREP_COLORS='ms=01;91'

# Set CONDA_BUILD_SYSROOT so that conda installed ROOT works
export CONDA_BUILD_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/