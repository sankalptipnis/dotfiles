#!/usr/bin/env bash

if [[ "$COLORTERM" == gnome-* && "$TERM" == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color'
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color'
fi

if [ -r "${HOMEBREW_PREFIX}/opt/gitstatus/gitstatus.plugin.sh" ]; then
	source "${HOMEBREW_PREFIX}/opt/gitstatus/gitstatus.plugin.sh"
	gitstatus_stop && gitstatus_start -s -1 -u -1 -c -1 -d -1
	prompt_git() {
		local s=''
		local branchName=''

		# Check if the current directory is in a Git repository.
		gitstatus_query && [[ "$VCS_STATUS_RESULT" == ok-sync ]] || return

		if [[ -n "$VCS_STATUS_LOCAL_BRANCH" ]]; then
			branchName="$VCS_STATUS_LOCAL_BRANCH"
		elif [[ -n "$VCS_STATUS_TAG" ]]; then
			branchName="$VCS_STATUS_TAG"
		else
			branchName="${VCS_STATUS_COMMIT:0:8}"
		fi

		(( VCS_STATUS_HAS_STAGED    )) && s+='+'
		(( VCS_STATUS_HAS_UNSTAGED  )) && s+='!'
		(( VCS_STATUS_HAS_UNTRACKED )) && s+='?'

		[ -n "${s}" ] && s=" [${s}]"

		echo -e "${1}${branchName}${2}${s}"
	}
else
	prompt_git() {
		local s=''
		local branchName=''

		# Check if the current directory is in a Git repository.
		git rev-parse --is-inside-work-tree &>/dev/null || return

		# Check for what branch we’re on.
		# Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
		# tracking remote branch or tag. Otherwise, get the
		# short SHA for the latest commit, or give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git describe --all --exact-match HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')"

		# Early exit for Chromium & Blink repo, as the dirty check takes too long.
		# Borrowed from https://github.com/paulirish/dotfiles/blob/dd33151f/.bash_prompt#L110-L123
		repoUrl="$(git config --get remote.origin.url)"
		if grep -q 'chromium/src.git' <<< "${repoUrl}"; then
			s+='*'
		else
			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+'
			fi
			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!'
			fi
			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?'
			fi
			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$'
			fi
		fi

		[ -n "${s}" ] && s=" [${s}]"

		echo -e "${1}${branchName}${2}${s}"
	}
fi

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold)
	reset=$(tput sgr0)

	black=$(tput setaf 0)
	red=$(tput setaf 1)
	green=$(tput setaf 2)
	yellow=$(tput setaf 3)
	blue=$(tput setaf 4)
	magenta=$(tput setaf 5)
	cyan=$(tput setaf 6)
	white=$(tput setaf 7)

	brightblack=$(tput setaf 8)
	brightred=$(tput setaf 9)
	brightgreen=$(tput setaf 10)
	brightyellow=$(tput setaf 11)
	brightblue=$(tput setaf 12)
	brightmagenta=$(tput setaf 13)
	brightcyan=$(tput setaf 14)
	brightwhite=$(tput setaf 15)
else
	bold=''; # empty string because all colors defined below are bold
	reset="\e[0m"

	black="\e[1;30m"
	red="\e[1;31m"
	green="\e[1;32m"
	yellow="\e[1;33m"
	blue="\e[1;34m"
	magenta="\e[1;35m"
	cyan="\e[1;36m"
	white="\e[1;37m"

	brightblack="\e[1;90m"
	brightred="\e[1;91m"
	brightgreen="\e[1;92m"
	brightyellow="\e[1;93m"
	brightblue="\e[1;94m"
	brightmagenta="\e[1;95m"
	brightcyan="\e[1;96m"
	brightwhite="\e[1;97m"
fi


# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${bold}${red}";
else
	userStyle="${brightblue}";
fi

# Set the terminal title and prompt.
PS1="\[${bold}\]"; # bold
PS1+="\[${userStyle}\]\u" # username

if [[ "${SSH_TTY}" ]]; then 
	PS1+="\[${brightwhite}\] at "
	PS1+="\[${brightyellow}\]\h" # hostname
fi

PS1+="\[${brightwhite}\] in "
PS1+="\[${brightgreen}\]\w"; # working directory full path
PS1+="\$(prompt_git \"\[${brightwhite}\] on \[${brightmagenta}\]\" \"\[${brightcyan}\]\")" # Git repository details
PS1+="\n";
PS1+="\[${brightwhite}\]\$ \[${reset}\]" # `$` (and reset color)

PROMPT_COMMAND="printf '\n'"
export PS1

PS2="\[${brightyellow}\]→ \[${reset}\]"
export PS2
