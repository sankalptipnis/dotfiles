#!/usr/bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Define dotfiles directory
export DOTFILES_DIR="$HOME/dotfiles"

# Initialize shell
[[ -r "$DOTFILES_DIR/shell/.init.sh" ]] && source "$DOTFILES_DIR/shell/.init.sh"

# Load history settings
[[ -r "$DOTFILES_DIR/zsh/.zsh_hist.zsh" ]] && source "$DOTFILES_DIR/zsh/.zsh_hist.zsh"

# Load color definitions
[[ -r "$DOTFILES_DIR/zsh/.zsh_colors.zsh" ]] && source "$DOTFILES_DIR/zsh/.zsh_colors.zsh"

# Shell settings
setopt NO_CASE_GLOB
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL

# Initialize Zoxide 
eval "$(zoxide init zsh)"

# Initialze fzf
_fzf_script="$DOTFILES_DIR/fzf/.fzf.zsh"
[[ -r "$_fzf_script" ]] && source "$_fzf_script"


# Initialize auto completion
_auto_complete_script="$DOTFILES_DIR/submodules/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
if [[ -r "$_auto_complete_script" ]]; then
	source "$_auto_complete_script"
	zstyle ':autocomplete:*' min-input 2
	zstyle ':autocomplete:*' insert-unambiguous yes
	zstyle ':autocomplete:*' widget-style menu-complete
fi

# Use LS_COLORS for auto complete
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Conda completion
fpath+=$DOTFILES_DIR/submodules/conda-zsh-completion

# SSH completion
h=("${(@f)$(cat ~/.ssh/config | grep "^Host" | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')}")
zstyle ':completion:*:(ssh|scp|rsync):*' hosts $h

# Initialize powerlevel10k
_powerline_script="$HOMEBREW_PREFIX/opt/powerlevel10k/powerlevel10k.zsh-theme"
[[ -r "$_powerline_script" ]] && source "$_powerline_script"

# Initialize auto suggestions
_auto_suggestions_script="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [[ -r "$_auto_suggestions_script" ]]; then
	source "$_auto_suggestions_script"
	export ZSH_AUTOSUGGEST_STRATEGY=(history)
	bindkey '^[pick_auto_suggestion' autosuggest-accept
	# uncomment below line if ZSH_AUTOSUGGEST_STRATEGY includes 'completion'
	# autoload compinit && compinit 
fi

# Initialize auto syntax highlight
_auto_syntax_highlight_script="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$_auto_syntax_highlight_script" ]] && source "$_auto_syntax_highlight_script"

# Initialize prompt 
_p10k_script="$DOTFILES_DIR/p10k/.p10k.zsh"
[[ ! -f "$_p10k_script" ]] || source "$_p10k_script"