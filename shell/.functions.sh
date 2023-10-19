#!/usr/bin/env bash

# Activate cern conda environment and get kerberos ticket for lxplus access
# function lxplus() {
# 	if ! /usr/bin/klist -s; then
# 		/usr/bin/kinit -kt ~/.ssh/keytab stipnis@CERN.CH
# 	fi
# 	ssh stipnis@lxplus.cern.ch \
# 	-R 52698:localhost:52698 \
# 	-L 8889:localhost:8889 \
# 	-o ForwardX11Trusted=yes \
# 	-o ForwardX11=yes \
# 	-o GSSAPITrustDns=yes \
# 	-o GSSAPIAuthentication=yes \
# 	-o GSSAPIDelegateCredentials=yes
# }

function lxplus() {
	ssh stipnis@lxplus-gpu.cern.ch \
	-R 52698:localhost:52698 \
	-L 8889:localhost:8889 \
	-o ForwardX11Trusted=yes \
	-o ForwardX11=yes
}

# Usage: pfdmerge output-file input-file-1 ... input-file-n
function mergepdf() { 
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile="$1" "${@:2}" 
}

# Create a new directory and enter it
function mkd() {
	mkdir -p "$1" && cd "$1"
}

# Show directory contents when moving into it
function cdls() {
    cd "$1" && la
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Empty the Trash
function emptytrash() { 
	if eval "osascript -e 'tell application \"Finder\" to empty trash'"; then
		echo "Successfully emptied the Trash"
	else
		echo "Failed to empty the Trash"
	fi
}

# Colorized size of (1) the contents of the current/given directory or (2) the given file
function fs() {

	local BOLD RED RESET IS_DIR LOC SIZES_ALL SIZE_TOTAL SIZES NAMES COMBINED  
	
	BOLD=$(tput bold)
	RED=$(tput setaf 9)
	RESET=$(tput sgr0)

	IS_DIR="FALSE"

	if [[ $# -eq 0 ]]; then
		LOC="$PWD"
		IS_DIR="TRUE"
	else
		LOC="$1"
		[[ -d "$LOC" ]] && IS_DIR="TRUE"
	fi

	[[ ! -e "$LOC" ]] && echo -e "${RED}${LOC}: No such file or directory${RESET}" && return

	if [[ "$IS_DIR" == "TRUE" ]]; then
		mapfile -t SIZES_ALL < <(du --summarize --human-readable --total -- "$LOC"/.[!.]* "$LOC"/* 2> >(grep -v '.[!.]*'\'': No such file or directory' >&2))
		SIZE_TOTAL=${SIZES_ALL[-1]}
		SIZES=("${SIZES_ALL[@]::${#SIZES_ALL[@]}-1}")
		mapfile -t SIZES < <(printf "%s\n" "${SIZES[@]}" | sed 's/\s.*//')
	else
		mapfile -t SIZES < <(du --summarize --human-readable -- "$LOC" 2> >(grep -v '.[!.]*'\'': No such file or directory' >&2))
		mapfile -t SIZES < <(printf "%s\n" "${SIZES[@]}" | sed 's/\s.*//')
	fi

	mapfile -t NAMES < <(ls --color=always -1 --almost-all "$LOC")

	mapfile -t COMBINED < <(paste <(printf "%s\n" "${SIZES[@]}") <(printf "%s\n" "${NAMES[@]}"))

	printf "\n"
	[[ -n "${NAMES[*]}" ]] && printf "%s\n" "${COMBINED[@]}" | sort --human-numeric-sort
	[[ "$IS_DIR" == "TRUE" ]] && printf "${BOLD}%s${RESET}\n" "${SIZE_TOTAL[@]}"
}

# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location(s)
function s() {
	if [[ $# -eq 0 ]]; then
		subl .
	else
		subl "$@"
	fi
}

# `v` with no arguments opens the current directory in VSCode, otherwise
# opens the given location(s)
function v() {
	if [[ $# -eq 0 ]]; then
		code .
	else
		code "$@"
	fi
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location(s)
function o() {
	if [[ $# -eq 0 ]]; then
		open .
	else
		open "$@"
	fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Prepend dirictory (if it exists) to the PATH variable
function prepend-path() {
  	[[ -d "$1" ]] && PATH="$1:$PATH"
}

# Use macOS Preview to open a man page in a more handsome format
function manp() {
  	man -t "$1" | open -f -a Preview
}

# Do a Matrix movie effect of falling characters
function matrix() {
	echo -e "\e[1;40m" ; clear ; while :; do echo "$LINES" "$COLUMNS" $(( "$RANDOM" % "$COLUMNS")) $(( "$RANDOM" % 72 )) ;sleep 0.05; done|gawk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

function matrix2() {
	echo -e "\e[1;40m" ; clear ; characters=$( jot -c 94 33 | tr -d '\n' ) ; while :; do echo "$LINES" "$COLUMNS" $(( "$RANDOM" % "$COLUMNS" )) $(( "$RANDOM" % 72 )) "$characters" ;sleep 0.05; done|gawk '{ letters=$5; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
# More information can be found in https://github.com/Canop/broot
function br {
    local cmd cmd_file code
    cmd_file=$(mktemp)
    if broot --outcmd "$cmd_file" "$@"; then
        cmd=$(<"$cmd_file")
        rm -f "$cmd_file"
        eval "$cmd"
    else
        code=$?
        rm -f "$cmd_file"
        return "$code"
    fi
}

# Rename iTerm tab
function renametab () {
    echo -ne "\033]0;$1\007"
}

# Use Git’s colored diff when available
if command -v git &>/dev/null; then
	function diff() {
		git diff --no-index "$@"
	}
fi

# Get Bundle ID of an app (useful for duti)
function bundleid () {
	local APP="$1"
    osascript -e "id of app \"$APP\""
}

# Print configured shell colors
function colors(){
	local LS_COLORS_ARRAY
	IFS=: read -ra LS_COLORS_ARRAY <<< "$LS_COLORS"
	for ls_color in "${LS_COLORS_ARRAY[@]}"; do # For all colors
	   	color=${ls_color##*=}
	   	ext=${ls_color%%=*}
	   	echo -en "\E[${color}m${ext}\E[0m " # echo color and extension
	 	echo	
	done
	echo
}

# Print all xterm 256 foreground colors
function colors256(){
	local bold, color, i, j
	for bold in {0..1}; do
		for color in {0..15}; do
			printf "\e[$bold;38;5;%sm  %3s  \e[0m" "$color" "$color"
			if [ $((color % 8)) == 7 ]; then echo; fi
		done
		echo
		for i in {0..5}; do for j in {16..33}; do
			color=$((j + 36*i))
			printf "\e[$bold;38;5;%sm  %3s  \e[0m" "$color" "$color"
			if [ $((color % 18)) == 15 ]; then echo; fi
		done; done
		echo
		for i in {0..5}; do for j in {34..51}; do
			color=$((j + 36*i))
			printf "\e[$bold;38;5;%sm  %3s  \e[0m" "$color" "$color"
			if [ $((color % 18)) == 15 ]; then echo; fi
		done; done
		echo
		for color in {232..255}; do
		    printf "\e[$bold;38;5;%sm  %3s  \e[0m" "$color" "$color"
		    if [ $((color % 8)) == 7 ]; then echo; fi
		done
		echo
	done
}

# Print all xterm 256 background colors
function colors256b(){
	local color, i, j
	for color in {0..15}; do
		printf "\e[48;5;%sm  %3s  \e[0m" "$color" "$color"
		if [ $((color % 8)) == 7 ]; then echo; fi
	done
	echo
	for i in {0..5}; do for j in {16..33}; do
		color=$((j + 36*i))
		printf "\e[48;5;%sm  %3s  \e[0m" "$color" "$color"
		if [ $((color % 18)) == 15 ]; then echo; fi
	done; done
	echo
	for i in {0..5}; do for j in {34..51}; do
		color=$((j + 36*i))
		printf "\e[48;5;%sm  %3s  \e[0m" "$color" "$color"
		if [ $((color % 18)) == 15 ]; then echo; fi
	done; done
	echo
	for color in {232..255}; do
	    printf "\e[48;5;%sm  %3s  \e[0m" "$color" "$color"
	    if [ $((color % 8)) == 7 ]; then echo; fi
	done
}

# Print all ANSI color combinations
function allcolors(){
	local color, background, bold
	for colour in 3{0..7} 9{0..7}
		do for background in 4{0..7} 10{0..7}
			do for bold in 0 1 2
				do echo -e "$bold;$colour;$background \e[$bold;${colour};${background}mSubdermatoglyphic text\e[00m"
				echo
			done
		done
	done
}