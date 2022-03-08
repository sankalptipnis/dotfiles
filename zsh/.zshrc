#!/usr/bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Get Homebrew prefix
if [[ "$(uname -m)" == "arm64" ]]; then 
	HOMEBREW_PREFIX=/opt/homebrew
else
	HOMEBREW_PREFIX=/usr/local
fi

# Define dotfiles directory
export DOTFILES_DIR="$HOME/dotfiles"

# Load color definitions
[ -r "$DOTFILES_DIR/zsh/.zsh_colors.zsh" ] && source "$DOTFILES_DIR/zsh/.zsh_colors.zsh"

# Load exports, aliases, functions, and PATH
for file in "$DOTFILES_DIR"/shell/.{exports,aliases,functions,path}.sh; do
	[ -r "$file" ] && source "$file"
done
unset file

# Load LS_COLORS
if is-executable -q dircolors; then
	[ -r "$DOTFILES_DIR/shell/.dircolors.sh" ] && eval "$(dircolors $DOTFILES_DIR/shell/.dircolors.sh)"
fi

# Add global ROOT to PYTHONPATH so it is accessible from conda envs
prefix=".."
suffix="/bin/root"
ROOT_LIB_DIR=$(readlink $(which root))
ROOT_LIB_DIR=${ROOT_LIB_DIR#"$prefix"}
ROOT_LIB_DIR=${ROOT_LIB_DIR%"$suffix"}
ROOT_LIB_DIR="$(brew --prefix)${ROOT_LIB_DIR}/lib/root"
PYTHONPATH="$ROOT_LIB_DIR:$PYTHONPATH"
PYTHONPATH=${PYTHONPATH%":"}
[ -d "$ROOT_LIB_DIR" ] && export PYTHONPATH

# Shell settings
setopt NO_CASE_GLOB
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL

# History settings
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

# Conda initialize
_conda_script="$HOMEBREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh"
[[ -r "$_conda_script" ]] && source "$_conda_script"

# Zoxide initialize
eval "$(zoxide init zsh)"

# Auto completion initialize
_auto_complete_script="$DOTFILES_DIR/submodules/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
if [[ -r "$_auto_complete_script" ]]; then
	source "$_auto_complete_script"
	zstyle ':autocomplete:*' min-input 1
	zstyle ':autocomplete:*' insert-unambiguous yes
	zstyle ':autocomplete:*' widget-style menu-complete
fi

# powerlevel10k initialize
_powerline_script="$HOMEBREW_PREFIX/opt/powerlevel10k/powerlevel10k.zsh-theme"
[[ -r "$_powerline_script" ]] && source "$_powerline_script"

# Auto suggestions initialize
_auto_suggestions_script="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [[ -r "$_auto_suggestions_script" ]]; then
	source "$_auto_suggestions_script"
	export ZSH_AUTOSUGGEST_STRATEGY=(history)
	bindkey '^[pick_auto_suggestion' autosuggest-accept
	# uncomment below line if ZSH_AUTOSUGGEST_STRATEGY includes 'completion'
	# autoload compinit && compinit 
fi

# Auto syntax highlight initialize
_auto_syntax_highlight_script="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$_auto_syntax_highlight_script" ]] && source "$_auto_syntax_highlight_script"

# Prompt initialize 
[[ ! -f "$DOTFILES_DIR/p10k/.p10k.zsh" ]] || source "$DOTFILES_DIR/p10k/.p10k.zsh"