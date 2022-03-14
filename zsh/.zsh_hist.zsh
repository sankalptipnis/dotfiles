#!/usr/bin/env zsh

setopt EXTENDED_HISTORY
SAVEHIST=10000
HISTSIZE=10000

# share history across multiple zsh sessions
setopt SHARE_HISTORY

# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 

# do not store duplications
setopt HIST_IGNORE_DUPS

#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS

# removes blank lines from history
setopt HIST_REDUCE_BLANKS