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

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias drive="cd ~/Drive/"
alias dot="cd $DOTFILES_DIR"
alias vdot="code $DOTFILES_DIR"
alias notes="cd ~/Drive/Notes"

# Conda environment activation
alias ca="conda activate"
alias cda="conda deactivate"

# Homebrew shortcuts
alias buz="brew uninstall --zap"
alias bout="brew update; brew outdated"
alias bup="brew update; brew upgrade; brew cleanup"
alias brm="brew bundle cleanup --file=$DOTFILES_DIR/homebrew/Brewfile; brew autoremove --dry-run"

# Git shortcuts
alias gst="git status"
alias gm="git merge"
alias gf="git fetch"
alias gpull="git pull"
alias gpush="git push"
alias ga="git add"
alias gbr="git branch"
alias gc="git commit -m"
alias gd="git diff"
alias gdst="git diff --staged"
alias gco="git checkout"
alias grestore="git restore"
alias gunstage="git restore --staged"

alias gl1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold brightblue)%h%C(reset) - %C(bold brightgreen)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"
alias gl2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold brightblue)%h%C(reset) - %C(bold brightcyan)%aD%C(reset) %C(bold brightgreen)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
alias gl3="git log --graph --abbrev-commit --decorate --format=format:'%C(bold brightblue)%h%C(reset) - %C(bold brightcyan)%aD%C(reset) %C(bold brightgreen)(%ar)%C(reset) %C(white)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'"
alias gl="gl1 -10"

alias gh1="gl1 --all"
alias gh2="gl2 --all"
alias gh3="gl3 --all"
alias gh="gl1 -10"

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
alias l="ls -lhF ${colorflag} --group-directories-first"

# List all files colorized in long format, including dot files
alias la="ls -lhAF ${colorflag} --group-directories-first"

# List only directories
alias lsd="ls -lhF ${colorflag} --group-directories-first | grep --color=never '^d'"

# List all directories
alias lad="ls -lhAF ${colorflag} --group-directories-first | grep --color=never '^d'"

# List only dotfiles
alias ldot="ls -ld .* --group-directories-first ${colorflag}"

# broot with sensible options
alias bra="br -sdph"

# Enable aliases to be sudo’ed
alias sudo="sudo "

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl;"

# URL-encode strings
alias urlencode='python -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))"'

# Intuitive map function
alias map="xargs -n1"

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume output volume 100'"

# Reload the shell (i.e. invoke as a login shell)
alias reload="unset PATH;exec -l "$SHELL";clear"

# Update macOS and Homebrew
alias updateall="sudo softwareupdate -i -a; brew update; brew upgrade; brew cu; brew cleanup"

# Update Homebrew
alias update="brew update; brew upgrade; brew cu; brew cleanup"

# Copy pwd to clipboard
alias cpwd="pwd|tr -d '\n'|pbcopy"

# Get weather
alias weather='curl wttr.in/London'

# List declared aliases
alias aliases="alias | sed 's/=.*//'"

# List declared functions
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"

# Always enable colored `grep` output
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Print sleep and wake log
alias sleeplog='pmset -g log|grep -e " Sleep  " -e " Wake  "'

# Open diff in VSCode
alias vdiff="code --diff"