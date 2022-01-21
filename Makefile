# Debug mode only prints to console, and does not run any commands
# DEBUG = TRUE

SHELL := /bin/bash

# Path to Makefile cannot contain spaces!
DOTFILES_DIR := $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
HOMEBREW_PREFIX := $(shell bin/is-evaluable bin/is-arm64 /opt/homebrew /usr/local)
PATH := $(DOTFILES_DIR)/bin:$(PATH)

CONFIG_DIR := $(HOME)/.config

GREEN_ECHO_PREFIX = '\033[92m'
GREEN_ECHO_SUFFIX = '\033[0m'

# .PHONY: list
# list:
#     @LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))


default: all


print:
ifndef DEBUG
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ NOT DEBUG MODE"$(GREEN_ECHO_SUFFIX)
else
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ DEBUG MODE"$(GREEN_ECHO_SUFFIX)
endif


all: sudo core cleanup link macos-defaults packages quicklook dock app-setup default-apps


###############################################################################
# Sudo 			                                                              #
###############################################################################

sudo:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Making sudo passwordless"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if sudo [ ! -f /etc/sudoers.d/$$(id -un) ]; then \
		echo "$$(id -un) ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$$(id -un); \
	fi
endif


sudo-revert:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Making sudo require password"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if sudo [ -f /etc/sudoers.d/$$(id -un) ]; then \
		sudo rm -f /etc/sudoers.d/$$(id -un); \
	fi
endif


###############################################################################
# Core utils: brew, bash, git & stow			      					      #
###############################################################################

core: brew bash git


brew: sudo
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	(is-executable brew && echo-color yellow "  Homebrew is aleady installed") || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
endif


bash: BASH := $(HOMEBREW_PREFIX)/bin/bash
bash: SHELLS := /private/etc/shells
bash: sudo brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing bash and setting it as the defualt shell"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 && \
		echo $(BASH) | sudo tee -a $(SHELLS) && \
		sudo chsh -s $(BASH) $$(id -un); \
	fi
endif


git: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing git if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	(is-executable git && echo-color yellow "  git is aleady installed") || (echo-color yellow "  Installing git" && brew install git)
endif


###############################################################################
# Deletion of .DS_Store files					      					      #
###############################################################################

cleanup:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Recursively deleting .DS_Store files"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	find $(DOTFILES_DIR) -name '.DS_Store' -type f -delete
endif


###############################################################################
# Linking of dotfiles							      					      #
###############################################################################

link: link-bash link-git link-xquartz link-kerberos link-ssh link-mopidy link-ncmpcpp link-hammerspoon link-spotifyd


link-bash: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking bash dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	stowup $(DOTFILES_DIR)/bash $(HOME)
	stowup $(DOTFILES_DIR)/bash_helpers $(HOME)
endif


link-git: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking git dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	stowup $(DOTFILES_DIR)/git $(HOME)
endif


link-xquartz: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking xquartz dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	stowup $(DOTFILES_DIR)/xquartz $(HOME)
endif


link-kerberos: KERBEROS_DIR := /etc
link-kerberos: sudo cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking kerberos dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	sudo cp -v --backup --suffix=.bak $(DOTFILES_DIR)/kerberos/* $(KERBEROS_DIR)
endif


link-ssh: SSH_DIR := $(HOME)/.ssh
link-ssh: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking ssh dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	stowup $(DOTFILES_DIR)/ssh $(SSH_DIR)
endif


link-mopidy: MOPIDY_DIR := $(CONFIG_DIR)/mopidy
link-mopidy: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking mopidy dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	stowup -c $(DOTFILES_DIR)/mopidy $(MOPIDY_DIR)
endif


link-ncmpcpp: NCMPCPP_DIR := $(CONFIG_DIR)/ncmpcpp
link-ncmpcpp: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking ncmpcpp dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	stowup $(DOTFILES_DIR)/ncmpcpp $(NCMPCPP_DIR)
endif


link-spotifyd: SPOTIFYD_DIR := $(CONFIG_DIR)/spotifyd
link-spotifyd: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking spotifyd dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	stowup -c $(DOTFILES_DIR)/spotifyd $(SPOTIFYD_DIR)
endif


link-hammerspoon: HAMMERSPOON_DIR := $(HOME)/.hammerspoon
link-hammerspoon: cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking hammerspoon dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	stowup $(DOTFILES_DIR)/hammerspoon $(HAMMERSPOON_DIR)
endif


###############################################################################
# macOS defaults       							      					      #
###############################################################################

macos-defaults: sudo
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting sensible macOS defaults"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/macos/defaults.sh || echo-color red "  Failed to set macOS defaults"
endif


###############################################################################
# Package and app installations	 				      					      #
###############################################################################

packages: brew-packages cask-apps mas-apps


brew-packages: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew packages"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Brewfile || echo-color red "  Failed to install all the Homebrew packages"
endif


cask-apps: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew Cask apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Caskfile || echo-color red "  Failed to install all the Homebrew Cask apps"
endif


mas-apps: brew mas
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing macOS App Store apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Masfile || echo-color red "  Failed to install all the macOS App Store apps"
endif


mas: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mas-cli is it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	(is-executable mas && echo-color yellow "  mas-cli is aleady installed") || (echo-color yellow "  Installing mas-cli" && brew install mas)
endif


###############################################################################
# Removing quarantine from quicklook plugins 							      #
###############################################################################

quicklook:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Removing quarantine from quicklook plugins"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	([ -d $(HOME)/Library/QuickLook ] && xattr -d -r com.apple.quarantine $(HOME)/Library/QuickLook) || echo-color yellow "  $(HOME)/Library/QuickLook does not exist"
endif


###############################################################################
# Dock setup 				      					 					      #
###############################################################################

dock: dockutil
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Organising the dock"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/macos/dock.sh || echo-color red "  Failed to set up the dock"
endif


dockutil: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing dockutil is it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	(is-executable dockutil && echo-color yellow "  dockutil is aleady installed") || (echo-color yellow "  Installing dockutil" && brew install dockutil)
endif


###############################################################################
# App setup 				      					 					      #
###############################################################################

app-setup: vscode sublime iterm mamba mopidy


vscode: vscode-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up VSCode"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! is-executable code; then \
		ln -s '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' /usr/local/bin/ || echo-color red "  Failed to symlink code"; \
	fi
	
	cat $(DOTFILES_DIR)/apps/vscode/vscode-extensions.list | xargs -L1 code --install-extension || echo-color red "  Failed to install all the VSCode extensions"
endif


vscode-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing VSCode if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "Visual Studio Code.app"); then echo-color yellow "  Installing VSCode" && brew install vscode; \
	else  echo-color yellow "  VSCode is already installed"; fi
endif


sublime: sublime-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up Sublime Text & Merge"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! is-executable subl; then \
		ln -s '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' /usr/local/bin/ || echo-color red "  Failed to symlink subl"; \
	fi
	if ! is-executable smerge; then \
		ln -s '/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge' /usr/local/bin/ || echo-color red "  Failed to symlink smerge"; \
	fi
endif


sublime-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Sublime Text & Merge if they do not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "Sublime Text.app"); then echo-color yellow "  Installing Sublime Text" && brew install sublime-text; \
	else echo-color yellow "  Sublime Text is already installed"; fi

	if ! (ls /Applications | grep "Sublime Merge.app"); then echo-color yellow "  Installing Sublime Merge" && brew install sublime-merge; \
	else echo-color yellow "  Sublime Merge is already installed"; fi
endif


iterm: iterm-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Importing iTerm color schemes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/apps/iterm/import-color-schemes.sh || echo-color red "  Failed to import iTerm color schemes"
endif


iterm-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing iTerm if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "iTerm.app"); then echo-color yellow "  Installing iTerm" && brew install iterm; \
	else echo-color yellow "  iTerm is already installed"; fi
endif


mamba: miniforge
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mamba in the base conda environment"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	conda install -y mamba -n base -c conda-forge || echo-color red "  Failed to install mamba"
endif


miniforge: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing miniforge if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	(is-executable conda && echo-color yellow "  miniforge is aleady installed") || (echo-color yellow "  Installing miniforge" && brew install miniforge)
endif


mopidy: mopidy-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Starting up mopidy as a servce"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew services start mopidy || echo-color red "  Failed to start mopidy as a service"
endif


mopidy-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mopidy and ncmpcpp if they do not not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	(is-executable mopidy && echo-color yellow "  mopidy is aleady installed") || (echo-color yellow "  Installing mopidy" && brew tap mopidy/mopidy && brew install mopidy mopidy-mpd mopidy-spotify)
	(is-executable ncmpcpp && echo-color yellow "  ncmpcpp is aleady installed") || (echo-color yellow "  Installing ncmpcpp" && brew install ncmpcpp)
endif


###############################################################################
# Default apps 				      					 					      #
###############################################################################

default-apps: duti
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up default apps for various filetypes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	duti -v $(DOTFILES_DIR)/duti/Dutifile || echo-color red "  Failed to set default apps"
endif


duti: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing duti if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	(is-executable duti && echo-color yellow "  duti is aleady installed") || (echo-color yellow "  Installing duti" && brew install duti)
endif


###############################################################################
# XCode Command Line Tools installation				 					      #
###############################################################################

clt:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing XCode Command Line Tools"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	xcode-select --install
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
		ktutil -k $(SSH_DIR)/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3; \
	fi
endif