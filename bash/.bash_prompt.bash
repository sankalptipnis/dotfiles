#!/usr/bin/env bash

_gitstatus_script="$HOMEBREW_PREFIX/opt/gitstatus/gitstatus.plugin.sh"

if [[ -r "$_gitstatus_script" ]]; then
	source "$_gitstatus_script"
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

		[[ -n "${s}" ]] && s=" [${s}]"

		echo -e "${1}${branchName}${2}${s}"
	}
else
	echo "slow git status!"
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
			if ! git diff --quiet --ignore-submodules --cached &>/dev/null; then
				s+='+'
			fi
			# Check for unstaged changes.
			if ! git diff-files --quiet --ignore-submodules -- &>/dev/null; then
				s+='!'
			fi
			# Check for untracked files.
			if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
				s+='?'
			fi
			# Check for stashed files.
			if git rev-parse --verify refs/stash &>/dev/null; then
				s+='$'
			fi
		fi

		[[ -n "${s}" ]] && s=" [${s}]"

		echo -e "${1}${branchName}${2}${s}"
	}
fi

# Highlight the user name when logged in as root.
if [[ "$USER" == "root" ]]; then
	userStyle="${BOLD}${RED}";
else
	userStyle="${BRIGHTBLUE}";
fi

# Set the terminal title and prompt.
PS1="\[${BOLD}\]"; # bold
PS1+="\[${userStyle}\]\u" # username

if [[ -n "${SSH_TTY}" ]]; then 
	PS1+="\[${BRIGHTWHITE}\] at "
	PS1+="\[${BRIGHTYELLOW}\]\h" # hostname
fi

PS1+="\[${BRIGHTWHITE}\] in "
PS1+="\[${BRIGHTGREEN}\]\w"; # working directory full path
PS1+="\$(prompt_git \"\[${BRIGHTWHITE}\] on \[${BRIGHTMAGENTA}\]\" \"\[${BRIGHTCYAN}\]\")" # Git repository details
PS1+="\n";
PS1+="\[${BRIGHTWHITE}\]\$ \[${RESET}\]" # `$` (and reset color)

PROMPT_COMMAND="printf '\n'"
export PS1

PS2="\[${BRIGHTYELLOW}\]→ \[${RESET}\]"
export PS2
