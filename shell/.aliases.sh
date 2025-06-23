#!/usr/bin/env bash

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Unix command shortcuts
alias rr="rm -rf"

# Shortcut for colorful echo
alias ec="echo-color"

# Shortcut for gdu-go
alias gfs="gdu-go"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias drive="cd ~/Drive/"
alias dot="cd $DOTFILES_DIR"
alias vdot="code $DOTFILES_DIR"
alias notes="cd ~/Drive/Notes"

# Conda shortcuts
alias ca="conda activate"
alias cda="conda deactivate"
alias cup="conda update --yes --name base --all && mamba update --yes --name cern --all"

# tlmgr update shortcut
alias lup="sudo tlmgr update --self --all --reinstall-forcibly-removed"

# Homebrew shortcuts
alias buz="brew uninstall --zap --cask"
alias bout="brew update; brew outdated"
alias bup="brew update; brew upgrade; brew cleanup"
alias bdeps="brew deps --tree"
alias buses="brew uses --installed"
alias bst="brew bundle cleanup --file=$DOTFILES_DIR/homebrew/Brewfile; echo; \
brew autoremove --dry-run; echo; \
brew bundle check --verbose --no-upgrade --file=$DOTFILES_DIR/homebrew/Brewfile"

# Git shortcuts
alias gst="git status"
alias gmerge="git merge"
alias gfetch="git fetch"
alias gpull="git pull"
alias gpush="git push"
alias gadd="git add"
alias gbr="git branch"
alias gc="git commit -m"
alias gd="git diff"
alias gdst="git diff --staged"
alias gco="git checkout"
alias grestore="git restore"
alias gunstage="git restore --staged"

alias glog1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold brightblue)%h%C(reset) - %C(bold brightgreen)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"
alias glog2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold brightblue)%h%C(reset) - %C(bold brightcyan)%aD%C(reset) %C(bold brightgreen)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
alias glog3="git log --graph --abbrev-commit --decorate --format=format:'%C(bold brightblue)%h%C(reset) - %C(bold brightcyan)%aD%C(reset) %C(bold brightgreen)(%ar)%C(reset) %C(white)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'"
alias glog="glog1 -10"

alias ghist1="glog1 --all"
alias ghist2="glog2 --all"
alias ghist3="glog3 --all"
alias ghist="ghist1 -10"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # macOS `ls`
	colorflag="-G"
	export LSCOLORS='BxGxFxFxCxDxDxCxCxbxbx'
fi

# Always use color output for `ls`
alias ls="ls ${colorflag}"

# List files colorized in long format
alias l="ls -lhF --group-directories-first"

# List all files colorized in long format, including dot files
alias la="ls -lhAF --group-directories-first"

# List only directories
alias lsd="ls -lhF --group-directories-first | grep --color=never '^d'"

# List all directories
alias lad="ls -lhAF --group-directories-first | grep --color=never '^d'"

# List only dotfiles
alias ldot="ls -ld .* --group-directories-first"

# broot with sensible options
alias bra="br -sdph"

# Enable aliases to be sudo’ed
alias sudo="sudo "

# Alias for delete binary
alias del="delete"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
alias emptyall="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl;"

# Eject all ejectale volumes
# Based on: https://apple.stackexchange.com/questions/86005/shortcut-to-eject-all-external-hard-drives-but-not-mobilebackups/
alias ejectall='osascript -e "tell application \"Finder\" to eject (every disk whose ejectable is true)"'

# Intuitive map function
alias map="xargs -n1"

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume output volume 100'"

# Reload the shell (i.e. invoke as a login shell)
alias reload="unset PATH; exec -l $SHELL; clear"

# Update macOS and Homebrew
alias updateall="sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup"

# Copy pwd to clipboard
alias cpwd="pwd | tr -d '\n'|pbcopy"

# Get weather
alias weather='curl wttr.in/London'

# Print Command Line Tools version
alias cltv='pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | grep version'

# List declared aliases
alias aliases="alias | sed 's/=.*//'"

# List declared functions
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"

# Always enable colored `grep` output
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Print sleep and wake log
alias sleeplog='pmset -g log | grep -e " Sleep  " -e " Wake  "'

# Open diff in VSCode
alias vdiff="code --diff"