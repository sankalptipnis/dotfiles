# Debug mode: 
# Prints out a summary of the targets being built, and does not run any commands
# For linking targets, it additionally prints out the linking/copying commands
# d = TRUE

SHELL := /bin/bash

# Path to Makefile cannot contain spaces!
DOTFILES_DIR := $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
BIN := $(DOTFILES_DIR)/bin
HOMEBREW_PREFIX := $(shell $(BIN)/is-evaluable $(BIN)/is-arm64 /opt/homebrew /usr/local)
PATH := $(BIN):$(PATH)

CONFIG_DIR := $(HOME)/.config
COMPLETED_DIR := $(HOME)/.completed

GREEN_ECHO_PREFIX = '\033[1;92m'
GREEN_ECHO_SUFFIX = '\033[0m'

ifdef d
	FLAG = -d
	DEBUG = TRUE
endif

.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

default: all

print:
ifndef DEBUG
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ NOT DEBUG MODE"$(GREEN_ECHO_SUFFIX)
else
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ DEBUG MODE"$(GREEN_ECHO_SUFFIX)
endif

all: completed sudo core cleanup link macos-defaults packages quicklook dock default-apps

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
	@echo

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
	@echo

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
	@echo

###############################################################################
# Core utils: brew, bash, git & stow			      					      #
###############################################################################

core: brew brew-path bash

brew: sudo
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! $(BIN)/is-executable -q brew; then \
		(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash) \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| ($(BIN)/echo-color red "  Failed to install Homebrew" && exit 1); \
	else \
		$(BIN)/echo-color yellow "  Homebrew is already installed"; \
	fi
endif
	@echo

brew-path: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Adding Homebrew to PATH"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	eval "$($(HOMEBREW_PREFIX)/bin/brew shellenv)" \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| ($(BIN)/echo-color red "  Failed to add Homebrew to PATH" && exit 1);
endif
	@echo

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
	@echo

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
	@echo

###############################################################################
# Linking of dotfiles							      					      #
###############################################################################

link: link-bash link-git link-conda link-xquartz link-kerberos link-ssh link-hammerspoon \
link-sublime-text link-vsc link-karabiner link-conda

link-shell: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking supplementary shell dotfiles"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/shell $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link supplementary shell dotfiles";
	@echo

link-bash: cleanup link-shell
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Bash dotfiles"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/bash $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link Bash dotfiles";
	@echo

link-p10k: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking powerlevel10k dotfiles"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/p10k $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link powerlevel10k dotfiles";
	@echo

link-zsh: cleanup link-shell link-p10k
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking ZSH dotfiles"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/zsh $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link ZSH dotfiles";
	@echo

link-git: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Git dotfiles"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/git $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link Git dotfiles";
	@echo

link-conda: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking conda dotfiles"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/conda/settings $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link conda dotfiles";
	@echo

link-xquartz: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking XQuartz dotfiles"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/xquartz $(HOME) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link XQuartz dotfiles";
	@echo

link-kerberos: KERBEROS_DIR := /etc
link-kerberos: sudo cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Kerberos files"$(GREEN_ECHO_SUFFIX)
	sudo $(BIN)/stowup -r $(FLAG) $(DOTFILES_DIR)/kerberos $(KERBEROS_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link Kerberos files";
	@echo

link-ssh: SSH_DIR := $(HOME)/.ssh
link-ssh: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking SSH files"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/ssh $(SSH_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link SSH files";
	@echo

link-hammerspoon: HAMMERSPOON_DIR := $(HOME)/.hammerspoon
link-hammerspoon: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Hammerspoon files"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/hammerspoon $(HAMMERSPOON_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link Hammerspoon files";
	@echo

link-vsc: VSC_DIR := "$(HOME)/Library/Application Support/Code/User"
link-vsc: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking VSC files"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x $(FLAG) $(DOTFILES_DIR)/vscode/settings $(VSC_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link VSC files";
	@echo

link-sublime-text: ST_DIR := "$(HOME)/Library/Application Support/Sublime Text/Packages"
link-sublime-text: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Sublime Text files"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x -D $(FLAG) $(DOTFILES_DIR)/sublime-text/User $(ST_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link  Sublime Text files";
	@echo

link-karabiner: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking Karabiner files"$(GREEN_ECHO_SUFFIX)
	$(BIN)/stowup -x -D $(FLAG) $(DOTFILES_DIR)/karabiner $(CONFIG_DIR) \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to link Karabiner files";
	@echo

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
	@echo

###############################################################################
# Package and app installations	 				      					      #
###############################################################################

packages: brew-apps gdu mas-apps mamba-pkgs vsc-extensions iterm-colors

brew-apps: brew svn
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew binaries and Cask apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle -v --file=$(DOTFILES_DIR)/homebrew/Brewfile \
	&& $(BIN)/echo-color yellow "  Success!" \
	|| $(BIN)/echo-color red "  Failed to install all the Homebrew packages/apps";
endif
	@echo

svn: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing SVN"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! $(BIN)/is-executable -q svn; then \
		brew install svn \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install SVN"; \
	else \
		$(BIN)/echo-color yellow "  SVN is already installed"; \
	fi
endif
	@echo

gdu: brew-apps
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing gdu"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! [[ -d $(HOMEBREW_PREFIX)/Cellar/gdu ]]; then \
		brew install -f gdu &&  brew link --overwrite gdu \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install gdu"; \
	else \
		$(BIN)/echo-color yellow "  gdu is already installed"; \
	fi
endif
	@echo

mas-apps: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing macOS App Store apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if $(BIN)/is-executable -q mas; then \
		brew bundle -v --file=$(DOTFILES_DIR)/homebrew/Masfile \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to install all the macOS App Store apps"; \
	else \
		$(BIN)/echo-color red "  mas-cli is not installed"; \
	fi
endif
	@echo

mamba-pkgs: mamba-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Creating mamba/conda environemnts"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if $(BIN)/is-executable -q mamba; then \
		$(DOTFILES_DIR)/conda/scripts/conda-envs-create.sh $(DOTFILES_DIR)/conda/envs \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to create all the mamba/conda environemnts"; \
	else \
		$(BIN)/echo-color red "  mamba is not installed"; \
	fi
endif
	@echo

mamba-install:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mamba in the base conda environment"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if $(BIN)/is-executable -q conda; then \
		if ! conda list | grep -q ^mamba; then \
			conda install -y mamba -n base -c conda-forge \
			&& $(BIN)/echo-color yellow "  Success!" \
			|| $(BIN)/echo-color red "  Failed to install mamba"; \
		else \
			$(BIN)/echo-color yellow "  mamba is already installed"; \
		fi; \
	else \
		$(BIN)/echo-color red "  miniforge is not installed"; \
	fi
endif
	@echo

vsc-extensions:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing VSCode extensions"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if (ls /Applications | grep -q "Visual Studio Code.app"); then \
		(cat $(DOTFILES_DIR)/vscode/extensions/Codefile | xargs -L1 code --install-extension) \
		&& $(BIN)/echo-color yellow "  Success: Installed VSCode extensions!" \
		|| $(BIN)/echo-color red "  Failed to install all the VSCode extensions"; \
	else \
		$(BIN)/echo-color red "  VSCode is not installed"; \
	fi	
endif
	@echo

iterm-colors:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Importing iTerm color schemes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if (ls /Applications | grep "iTerm.app"); then \
		if [ ! -f $(COMPLETED_DIR)/itermcol ]; then \
			$(DOTFILES_DIR)/iterm/scripts/import-color-schemes.sh \
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
	@echo


###############################################################################
# Removing quarantine from quicklook directory 							      #
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
	@echo

###############################################################################
# Dock setup 				      					 					      #
###############################################################################

dock:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Organising the dock"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
		if $(BIN)/is-executable -q dockutil; then \
			$(DOTFILES_DIR)/macos/dock.sh \
			&& $(BIN)/echo-color yellow "  Success!" \
			|| $(BIN)/echo-color red "  Failed to set up the dock"; \
		else \
			$(BIN)/echo-color red "  dockutil is not installed"; \
		fi
endif
	@echo

###############################################################################
# Default apps 				      					 					      #
###############################################################################

default-apps:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up default apps for various filetypes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if $(BIN)/is-executable -q duti; then \
		duti -v $(DOTFILES_DIR)/duti/Dutifile \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to set default apps"; \
	else \
		$(BIN)/echo-color red "  duti is not installed"; \
	fi
endif
	@echo

###############################################################################
# Keytab generation									 					      #
###############################################################################

keytab: SSH_DIR := $(HOME)/.ssh
keytab:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Generating keytab for lxplus access"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	mkdir -p $(SSH_DIR)
	if [ ! -f $(SSH_DIR)/keytab ]; then \
		/usr/sbin/ktutil -k $(SSH_DIR)/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3 \
		&& $(BIN)/echo-color yellow "  Success!" \
		|| $(BIN)/echo-color red "  Failed to generate keytab"; \
	else \
		$(BIN)/echo-color yellow "  keytab already exists"; \
	fi
endif
	@echo