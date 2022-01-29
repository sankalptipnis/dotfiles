# Debug mode only prints to console, and does not run any commands
# DEBUG = TRUE

SHELL := /bin/bash

# Path to Makefile cannot contain spaces!
DOTFILES_DIR := $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
BIN := $(DOTFILES_DIR)/bin
HOMEBREW_PREFIX := $(shell $(BIN)/is-evaluable $(BIN)/is-arm64 /opt/homebrew /usr/local)
PATH := $(BIN):$(PATH)

CONFIG_DIR := $(HOME)/.config
COMPLETED_DIR := $(HOME)/.completed

GREEN_ECHO_PREFIX = '\033[92m'
GREEN_ECHO_SUFFIX = '\033[0m'

.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

default: all

print:
ifndef DEBUG
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ NOT DEBUG MODE"$(GREEN_ECHO_SUFFIX)
else
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ DEBUG MODE"$(GREEN_ECHO_SUFFIX)
endif

all: completed sudo core cleanup link macos-defaults packages quicklook dock app-setup default-apps

###############################################################################
# Creation of ~/.completed 			                                          #
###############################################################################

completed:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Creating ~/.completed"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if [ ! -d $(COMPLETED_DIR) ]; then \
		mkdir $(COMPLETED_DIR) \
		&& echo-color yellow "  Success!" \
		|| (echo-color red "  Failed to create ~/.completed!" && exit 1); \
	else \
		$(BIN)/echo-color yellow "  ~/.completed already exists"; \
	fi
endif

###############################################################################
# Sudo 			                                                              #
###############################################################################

sudo:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Making sudo passwordless"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if sudo [ ! -f /etc/sudoers.d/$$(id -un) ]; then \
		(echo "$$(id -un) ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$$(id -un)) \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| ($(BIN)/echo-color red "  Failed to make sudo passwordless" && exit 1); \
	else \
		$(BIN)/echo-color yellow "  Sudo is already passwordless"; \
	fi
endif

sudo-revert:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Making sudo require a password"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if sudo [ -f /etc/sudoers.d/$$(id -un) ]; then \
		sudo rm -f /etc/sudoers.d/$$(id -un) \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to make sudo require a password"; \
	else \
		$(BIN)/echo-color yellow "  Sudo already requires a password"; \
	fi
endif

###############################################################################
# Core utils: brew, bash, git & stow			      					      #
###############################################################################

core: brew brew-path bash

brew: sudo
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! $(BIN)/is-executable brew; then \
		(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash) \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| ($(BIN)/echo-color red "  Failed to install Homebrew" && exit 1); \
	else \
		$(BIN)/echo-color yellow "  Homebrew is already installed"; \
	fi
endif

brew-path: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Adding Homebrew to PATH"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	eval "$($(HOMEBREW_PREFIX)/bin/brew shellenv)" \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| ($(BIN)/echo-color red "  Failed to add Homebrew to PATH" && exit 1);
endif

bash: BASH := $(HOMEBREW_PREFIX)/bin/bash
bash: SHELLS := /private/etc/shells
bash: sudo brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Bash and setting it as the default shell"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 \
		&& echo $(BASH) | sudo tee -a $(SHELLS) \
		&& sudo chsh -s $(BASH) $$(id -un) \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| ($(BIN)/echo-color red "  Failed to install Bash or to set it as the default shell" && exit 1); \
	else \
		$(BIN)/echo-color yellow "  Bash already set up"; \
	fi
endif

###############################################################################
# Cleanup of dotfiles directory					      					      #
###############################################################################

cleanup:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Cleaning up dotfiles directory"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	find $(DOTFILES_DIR) -name '.DS_Store' -type f -delete \
	&& find $(DOTFILES_DIR) -mindepth 1 -maxdepth 1 -not -name .git -exec xattr -d -r com.apple.quarantine '{}' \; \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| ($(BIN)/echo-color red "  Failed to clean up dotfiles directory" && exit 1);
endif

###############################################################################
# Linking of dotfiles							      					      #
###############################################################################

link: link-bash link-git link-xquartz link-kerberos link-ssh link-mopidy link-ncmpcpp link-hammerspoon link-spotifyd

link-bash: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Bash dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	$(BIN)/stowup -x $(DOTFILES_DIR)/bash $(HOME) \
	&& $(BIN)/echo-color yellow "  Success: Linked core Bash dotfiles" \
	|| $(BIN)/echo-color red "  Failed to link core Bash dotfiles";
	
	$(BIN)/stowup -x $(DOTFILES_DIR)/bash_helpers $(HOME) \
	&& $(BIN)/echo-color yellow "  Success: Linked supplementary Bash dotfiles!" \
	|| $(BIN)/echo-color red "  Failed to link supplementary Bash dotfiles";
endif

link-git: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Git dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	$(BIN)/stowup -x $(DOTFILES_DIR)/git $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link Git dotfiles";
endif

link-xquartz: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking XQuartz dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	$(BIN)/stowup -x $(DOTFILES_DIR)/xquartz $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link XQuartz dotfiles";
endif

link-kerberos: KERBEROS_DIR := /etc
link-kerberos: sudo cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Kerberos files"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	sudo $(BIN)/stowup $(DOTFILES_DIR)/kerberos $(KERBEROS_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link Kerberos files";
endif

link-ssh: SSH_DIR := $(HOME)/.ssh
link-ssh: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking SSH files"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	$(BIN)/stowup -x $(DOTFILES_DIR)/ssh $(SSH_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link SSH files";
endif

link-mopidy: MOPIDY_DIR := $(CONFIG_DIR)/mopidy
link-mopidy: cleanup completed
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Copying mopidy files"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if [ ! -f $(COMPLETED_DIR)/mopidyfiles ]; then \
		$(BIN)/stowup -x -c $(DOTFILES_DIR)/mopidy $(MOPIDY_DIR) \
		&& touch $(COMPLETED_DIR)/mopidyfiles \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to copy mopidy files"; \
	else \
		$(BIN)/echo-color yellow "  Mopidy files have already been copied."; \
		$(BIN)/echo-color yellow "  Delete $(COMPLETED_DIR)/mopidyfiles to be able to re-copy."; \
	fi
endif

link-ncmpcpp: NCMPCPP_DIR := $(CONFIG_DIR)/ncmpcpp
link-ncmpcpp: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking ncmpcpp files"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	$(BIN)/stowup -x $(DOTFILES_DIR)/ncmpcpp $(NCMPCPP_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link ncmpcpp files";
endif

link-spotifyd: SPOTIFYD_DIR := $(CONFIG_DIR)/spotifyd
link-spotifyd: cleanup completed
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Copying spotifyd dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if [ ! -f $(COMPLETED_DIR)/spotifydfiles ]; then \
		$(BIN)/stowup -x -c $(DOTFILES_DIR)/spotifyd $(SPOTIFYD_DIR) \
		&& touch $(COMPLETED_DIR)/spotifydfiles \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to copy spotifyd files"; \
	else \
		$(BIN)/echo-color yellow "  Spotifyd files have already been copied."; \
		$(BIN)/echo-color yellow "  Delete $(COMPLETED_DIR)/spotifydfiles to be able to re-copy."; \
	fi
endif

link-hammerspoon: HAMMERSPOON_DIR := $(HOME)/.hammerspoon
link-hammerspoon: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Hammerspoon files"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	$(BIN)/stowup -x $(DOTFILES_DIR)/hammerspoon $(HAMMERSPOON_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link Hammerspoon files";
endif

###############################################################################
# macOS defaults       							      					      #
###############################################################################

macos-defaults: sudo completed
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting sensible macOS defaults"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if [ ! -f $(COMPLETED_DIR)/defaults ]; then \
		$(DOTFILES_DIR)/macos/defaults.sh \
		&& touch $(COMPLETED_DIR)/defaults \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to set macOS defaults"; \
	else \
		$(BIN)/echo-color yellow "  macOS defaults have already been set."; \
		$(BIN)/echo-color yellow "  Delete $(COMPLETED_DIR)/defaults to be able to reset."; \
	fi
endif

###############################################################################
# Package and app installations	 				      					      #
###############################################################################

packages: brew-packages cask-apps mas-apps

brew-packages: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew packages"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Brewfile \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to install all the Homebrew packages";
endif

svn: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing SVN"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! $(BIN)/is-executable svn; then \
		brew install svn \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install SVN"; \
	else \
		$(BIN)/echo-color yellow "  SVN is already installed"; \
	fi
endif

cask-apps: brew svn
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew Cask apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
		brew bundle --file=$(DOTFILES_DIR)/homebrew/Caskfile \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| echo-color red "  Failed to install all the Homebrew Cask apps"; 
endif

mas-apps: brew mas
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing macOS App Store apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if $(BIN)/is-executable mas; then \
		brew bundle --file=$(DOTFILES_DIR)/homebrew/Masfile \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install all the macOS App Store apps"; \
	else \
		$(BIN)/echo-color red "  mas-cli is not installed"; \
	fi
endif

mas: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mas-cli"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	if ! $(BIN)/is-executable mas; then \
		brew install mas \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install mas-cli"; \
	else \
		$(BIN)/echo-color yellow "  mas-cli is already installed"; \
	fi
endif

###############################################################################
# Removing quarantine from quicklook plugins 							      #
###############################################################################

quicklook:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Removing quarantine from quicklook plugins"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	if [ -d $(HOME)/Library/QuickLook ]; then \
		xattr -d -r com.apple.quarantine $(HOME)/Library/QuickLook \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to remove quarantine from quicklook plugins"; \
	else \
		$(BIN)/echo-color yellow "  $(HOME)/Library/QuickLook does not exist"; \
	fi
endif

###############################################################################
# Dock setup 				      					 					      #
###############################################################################

dock: dockutil
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Organising the dock"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
		if $(BIN)/is-executable dockutil; then \
			$(DOTFILES_DIR)/macos/dock.sh \
			&& touch $(COMPLETED_DIR)/dock \
			&& $(BIN)/echo-color yellow "  Success!" \
			|| $(BIN)/echo-color red "  Failed to set up the dock"; \
		else \
			$(BIN)/echo-color red "  dockutil is not installed"; \
		fi
endif

dockutil: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing dockutil"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	if ! $(BIN)/is-executable dockutil; then \
		brew install dockutil \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install dockutil"; \
	else \
		$(BIN)/echo-color yellow "  dockutil is already installed"; \
	fi
endif

###############################################################################
# App setup 				      					 					      #
###############################################################################

app-setup: vscode subl smerge iterm mamba mopidy

vscode: CODE := '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
vscode: vscode-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up VSCode"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if (ls /Applications | grep -q "Visual Studio Code.app"); then \
		if ! $(BIN)/is-executable code; then \
			if [ -e $(CODE) ]; then \
				ln -s $(CODE) /usr/local/bin/ \
				&& $(BIN)/echo-color yellow "  Success: Symlinked code!" \
				|| $(BIN)/echo-color red "  Failed to symlink code"; \
			else \
				$(BIN)/echo-color red "  Failed to symlink code: $(CODE) does not exist "; \
			fi; \
		else \
			$(BIN)/echo-color yellow "  code is already a symlink"; \
		fi; \
		(cat $(DOTFILES_DIR)/apps/vscode/vscode-extensions.list | xargs -L1 code --install-extension) \
		&& $(BIN)/echo-color yellow "  Success: Installed VSCode extensions!" \
		|| $(BIN)/echo-color red "  Failed to install all the VSCode extensions"; \
	else \
		$(BIN)/echo-color red "  VSCode is not installed"; \
	fi	
endif

vscode-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing VSCode"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "Visual Studio Code.app"); then \
		brew install vscode \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install VSCode"; \
	else \
	  	$(BIN)/echo-color yellow "  VSCode is already installed"; \
  	fi
endif

subl: SUBL := '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'
subl: subl-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up Sublime Text"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if (ls /Applications | grep -q "Sublime Text.app"); then \
		if ! $(BIN)/is-executable subl; then \
			if [ -e $(SUBL) ]; then \
				ln -s $(SUBL) /usr/local/bin/ \
				&& $(BIN)/echo-color yellow "  Success: Symlinked subl!" \
				|| $(BIN)/echo-color red "  Failed to symlink subl"; \
			else \
				$(BIN)/echo-color red "  Failed to symlink subl: $(SUBL) does not exist "; \
			fi; \
		else \
			$(BIN)/echo-color yellow "  subl is already a symlink"; \
		fi; \
	else \
		$(BIN)/echo-color red "  Sublime Text is not installed"; \
	fi	
endif

subl-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Sublime Text"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "Sublime Text.app"); then \
		brew install sublime-text \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install Sublime Text"; \
	else \
	  	$(BIN)/echo-color yellow "  Sublime Text is already installed"; \
  	fi
endif

smerge: SMERGE := '/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge'
smerge: smerge-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up Sublime Merge"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if (ls /Applications | grep -q "Sublime Merge.app"); then \
		if ! $(BIN)/is-executable smerge; then \
			if [ -e $(SMERGE) ]; then \
				ln -s $(SMERGE) /usr/local/bin/ \
				&& $(BIN)/echo-color yellow "  Success: Symlinked smerge!" \
				|| $(BIN)/echo-color red "  Failed to symlink smerge"; \
			else \
				$(BIN)/echo-color red "  Failed to symlink smerge: $(SMERGE) does not exist "; \
			fi; \
		else \
			$(BIN)/echo-color yellow "  smerge is already a symlink"; \
		fi; \
	else \
		$(BIN)/echo-color red "  Sublime Merge is not installed"; \
	fi	
endif

smerge-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Sublime Merge"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "Sublime Merge.app"); then \
		brew install sublime-merge \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install Sublime Merge"; \
	else \
	  	$(BIN)/echo-color yellow "  Sublime Merge is already installed"; \
  	fi
endif

iterm: iterm-install completed
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Importing iTerm color schemes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if (ls /Applications | grep "iTerm.app"); then \
		if [ ! -f $(COMPLETED_DIR)/itermcol ]; then \
			$(DOTFILES_DIR)/apps/iterm/import-color-schemes.sh \
			&& touch $(COMPLETED_DIR)/itermcol \
			&& $(BIN)/echo-color yellow "  Success!" \
			|| $(BIN)/echo-color red "  Failed to import iTerm color schemes"; \
		else \
			$(BIN)/echo-color yellow "  iTerm color schemes have already been imported."; \
			$(BIN)/echo-color yellow "  Delete $(COMPLETED_DIR)/itermcol to be able to reimport."; \
		fi; \
	else \
		$(BIN)/echo-color red "  iTerm is not installed"; \
  	fi
endif

iterm-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing iTerm"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "iTerm.app"); then \
		brew install iterm \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install iTerm"; \
	else \
	  	$(BIN)/echo-color yellow "  iTerm is already installed"; \
  	fi
endif

mamba: miniforge
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mamba in the base conda environment"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if $(BIN)/is-executable conda; then \
		if ! conda list | grep -q ^mamba; then \
			conda install -y mamba -n base -c conda-forge \
			&& $(BIN)/echo-color yellow "  Success!" \
			|| $(BIN)/echo-color red "  Failed to install mamba"; \
		else \
			$(BIN)/echo-color yellow "  mamba is already installed"; \
		fi; \
	else \
		$(BIN)/echo-color red "  conda is not installed"; \
	fi
endif

miniforge: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing miniforge"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! $(BIN)/is-executable conda; then \
		brew install miniforge \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install miniforge"; \
	else \
		$(BIN)/echo-color yellow "  miniforge is already installed"; \
	fi
endif

mopidy: mopidy-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Starting up mopidy as a servce"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! brew services | grep -qE mopidy.*started; then \
		brew services start mopidy \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to start mopidy as a service"; \
	else \
		$(BIN)/echo-color yellow "  mopidy has already been started as a service"; \
	fi
endif

mopidy-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mopidy and ncmpcpp"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	if ! $(BIN)/is-executable mopidy; then \
		brew tap mopidy/mopidy \
		&& brew install mopidy mopidy-mpd mopidy-spotify \
		&& $(BIN)/echo-color yellow "  Success: Installed mopidy!" \
		|| $(BIN)/echo-color red "  Failed to install mopidy"; \
	else \
		$(BIN)/echo-color yellow "  mopidy is already installed"; \
	fi

	if ! $(BIN)/is-executable ncmpcpp; then \
		brew install ncmpcpp \
		&& $(BIN)/echo-color yellow "  Success: Installed ncmpcpp!" \
		|| $(BIN)/echo-color red "  Failed to install ncmpcpp"; \
	else \
		$(BIN)/echo-color yellow "  ncmpcpp is already installed"; \
	fi
endif

###############################################################################
# Default apps 				      					 					      #
###############################################################################

default-apps: duti
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up default apps for various filetypes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if $(BIN)/is-executable duti; then \
		duti -v $(DOTFILES_DIR)/duti/Dutifile \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to set default apps"; \
	else \
		$(BIN)/echo-color red "  duti is not installed"; \
	fi
endif

duti: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing duti"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! $(BIN)/is-executable duti; then \
		brew install duti \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install duti"; \
	else \
		$(BIN)/echo-color yellow "  duti is already installed"; \
	fi
endif

###############################################################################
# Keytab generation									 					      #
###############################################################################

keytab: SSH_DIR := $(HOME)/.ssh
keytab:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Generating keytab for lxplus access"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	mkdir -p $(SSH_DIR)
	if [ ! -f $(SSH_DIR)/keytab ]; then \
		ktutil -k $(SSH_DIR)/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3 \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to generate keytab"; \
	else \
		$(BIN)/echo-color yellow "  keytab already exists"; \
	fi
endif