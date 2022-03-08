#!/usr/bin/env bash

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="$HISTSIZE"

# 1. Append to history immediately after command
# 2. Clear current history
# 3. Reload updated history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Print the timestamp of each command in history
export HISTTIMEFORMAT='%F %T '

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth'