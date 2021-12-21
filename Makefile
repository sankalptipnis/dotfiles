# Debug mode only prints to console, and does not run any commands
DEBUG = TRUE

SHELL := /bin/bash

# Path to Makefile cannot contain spaces!
DOTFILES_DIR := $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
HOMEBREW_PREFIX := $(shell bin/is-evaluable bin/is-arm64 /opt/homebrew /usr/local)
PATH := $(DOTFILES_DIR)/bin:$(PATH)

CONFIG_DIR := $(HOME)/.config
MOPIDY_DIR := $(CONFIG_DIR)/mopidy
NCMPCPP_DIR := $(CONFIG_DIR)/ncmpcpp
SSH_DIR := $(HOME)/.ssh
KERBEROS_DIR := /etc
HAMMERSPOON_DIR := $(HOME)/.hammerspoon

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


all: sudo core cleanup link macos-defaults packages dock app-setup default-apps


###############################################################################
# Sudo 			                                                              #
###############################################################################

sudo:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Making sudo passwordless"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if sudo [ ! -f /etc/sudoers.d/sankalptipnis ]; then \
		echo "$$(id -un) ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/sankalptipnis; \
	fi
endif


sudo-revert:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Making sudo require password"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if sudo [ -f /etc/sudoers.d/sankalptipnis ]; then \
		sudo rm -f /etc/sudoers.d/sankalptipnis; \
	fi
endif


###############################################################################
# Core utils: brew, bash, git & stow			      					      #
###############################################################################

core: brew bash git stow


brew: sudo
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
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
	is-executable git || echo-color yellow "Installing git" && brew install git
endif


stow: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing GNU Stow if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable stow || echo-color yellow "Installing GNU Stow" && brew install stow
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

link: link-config link-bash link-git link-xquartz link-kerberos link-ssh link-mopidy link-ncmpcpp link-hammerspoon


link-config:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Creating config directory"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	mkdir -p $(CONFIG_DIR)
endif


link-bash: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking bash dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	for FILE in $$(\ls -A $(DOTFILES_DIR)/bash); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/bash; stow -vv -t $(HOME) .

	for FILE in $$(\ls -A $(DOTFILES_DIR)/bash_helpers); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/bash_helpers; stow -vv -t $(HOME) .
endif


link-git: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking git dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	for FILE in $$(\ls -A $(DOTFILES_DIR)/git); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/git; stow -vv -t $(HOME) .
endif


link-xquartz: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking xquartz dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	for FILE in $$(\ls -A $(DOTFILES_DIR)/xquartz); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/xquartz; stow -vv -t $(HOME) .
endif


link-kerberos: sudo stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking kerberos dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	for FILE in $$(\ls -A $(DOTFILES_DIR)/kerberos); do if [ -f $(KERBEROS_DIR)/$$FILE -a ! -h $(KERBEROS_DIR)/$$FILE ]; then \
		sudo mv -v $(KERBEROS_DIR)/$$FILE{,.bak}; fi; done
	sudo cp -v $(DOTFILES_DIR)/kerberos/* $(KERBEROS_DIR)
endif


link-ssh: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking ssh dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	mkdir -p $(SSH_DIR)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/ssh); do if [ -f $(SSH_DIR)/$$FILE -a ! -h $(SSH_DIR)/$$FILE ]; then \
		mv -v $(SSH_DIR)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/ssh; stow -vv -t $(SSH_DIR) .
endif


link-mopidy: stow cleanup link-config
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking mopidy dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	mkdir -p $(MOPIDY_DIR)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/mopidy); do if [ -f $(MOPIDY_DIR)/$$FILE -a ! -h $(MOPIDY_DIR)/$$FILE ]; then \
		mv -v $(MOPIDY_DIR)/$$FILE{,.bak}; fi; done
	cp -v $(DOTFILES_DIR)/mopidy/* $(MOPIDY_DIR)
endif


link-ncmpcpp: stow cleanup link-config
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking ncmpcpp dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	mkdir -p $(NCMPCPP_DIR)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/ncmpcpp); do if [ -f $(NCMPCPP_DIR)/$$FILE -a ! -h $(NCMPCPP_DIR)/$$FILE ]; then \
		mv -v $(NCMPCPP_DIR)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/ncmpcpp; stow -vv -t $(NCMPCPP_DIR) .
endif


link-hammerspoon: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Linking hammerspoon dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	mkdir -p $(HAMMERSPOON_DIR)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/apps/hammerspoon); do if [ -f $(HAMMERSPOON_DIR)/$$FILE -a ! -h $(HAMMERSPOON_DIR)/$$FILE ]; then \
		mv -v $(HAMMERSPOON_DIR)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/apps/hammerspoon; stow -vv -t $(HAMMERSPOON_DIR) .
endif


###############################################################################
# Unlinking of dotfiles							      					      #
###############################################################################

unlink: unlink-bash unlink-git unlink-xquartz unlink-kerberos unlink-ssh unlink-mopidy unlink-ncmpcpp unlink-hammerspoon


unlink-bash: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking bash dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	cd $(DOTFILES_DIR)/bash; stow --delete -vv -t $(HOME) .
	cd $(DOTFILES_DIR)/bash_helpers; stow --delete -vv -t $(HOME) .

	for FILE in $$(\ls -A $(DOTFILES_DIR)/bash); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

	for FILE in $$(\ls -A $(DOTFILES_DIR)/bash_helpers); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done
endif


unlink-git: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking git dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	cd $(DOTFILES_DIR)/git; stow --delete -vv -t $(HOME) .
	for FILE in $$(\ls -A $(DOTFILES_DIR)/git); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done
endif


unlink-xquartz: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking xquartz dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	cd $(DOTFILES_DIR)/xquartz; stow --delete -vv -t $(HOME) .
	for FILE in $$(\ls -A $(DOTFILES_DIR)/xquartz); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done
endif


unlink-kerberos: sudo stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking kerberos dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	for FILE in $$(\ls -A $(DOTFILES_DIR)/kerberos); do if [ -f $(KERBEROS_DIR)/$$FILE.bak ]; then \
		mv -v $(KERBEROS_DIR)/$$FILE.bak $(KERBEROS_DIR)/$${FILE%%.bak}; fi; done
endif


unlink-ssh: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking ssh dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	cd $(DOTFILES_DIR)/ssh; stow --delete -vv -t $(SSH_DIR) .
	for FILE in $$(\ls -A $(DOTFILES_DIR)/ssh); do if [ -f $(SSH_DIR)/$$FILE.bak ]; then \
		mv -v $(SSH_DIR)/$$FILE.bak $(SSH_DIR)/$${FILE%%.bak}; fi; done
endif


unlink-mopidy: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking mopidy dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	for FILE in $$(\ls -A $(DOTFILES_DIR)/mopidy); do if [ -f $(MOPIDY_DIR)/$$FILE.bak ]; then \
		mv -v $(MOPIDY_DIR)/$$FILE.bak $(MOPIDY_DIR)/$${FILE%%.bak}; fi; done
endif


unlink-ncmpcpp: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking ncmpcpp dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	cd $(DOTFILES_DIR)/ncmpcpp; stow --delete -vv -t $(NCMPCPP_DIR) .
	for FILE in $$(\ls -A $(DOTFILES_DIR)/ncmpcpp); do if [ -f $(NCMPCPP_DIR)/$$FILE.bak ]; then \
		mv -v $(NCMPCPP_DIR)/$$FILE.bak $(NCMPCPP_DIR)/$${FILE%%.bak}; fi; done
endif


unlink-hammerspoon: stow cleanup
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking hammerspoon dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	cd $(DOTFILES_DIR)/apps/hammerspoon; stow --delete -vv -t $(HAMMERSPOON_DIR) .
	for FILE in $$(\ls -A $(DOTFILES_DIR)/apps/hammerspoon); do if [ -f $(HAMMERSPOON_DIR)/$$FILE.bak ]; then \
		mv -v $(HAMMERSPOON_DIR)/$$FILE.bak $(HAMMERSPOON_DIR)/$${FILE%%.bak}; fi; done
endif


###############################################################################
# macOS defaults       							      					      #
###############################################################################

macos-defaults: sudo
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting sensible macOS defaults"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/macos/defaults.sh || echo-color red "Failed to set macOS defaults" && true
endif


###############################################################################
# Package and app installations	 				      					      #
###############################################################################

packages: brew-packages cask-apps mas-apps


brew-packages: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew packages"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Brewfile || echo-color red "Failed to install all the Homebrew packages" && true
endif


cask-apps: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew Cask apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Caskfile || echo-color red "Failed to install all the Homebrew Cask apps" && true
endif


mas-apps: brew mas
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing macOS App Store apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Masfile || echo-color red "Failed to install all the macOS App Store apps" && true
endif


mas: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mas-cli is it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	is-executable mas || echo-color yellow "Installing mas" && brew install mas
endif


###############################################################################
# Dock setup 				      					 					      #
###############################################################################

dock: dockutil
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Organising the dock"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/macos/dock.sh || echo-color red "Failed to set up the dock" && true
endif


dockutil: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing dockutil is it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	is-executable dockutil || echo-color yellow "Installing dockutil" && brew install dockutil
endif


###############################################################################
# App setup 				      					 					      #
###############################################################################

app-setup: vscode sublime iterm mamba mopidy


vscode: vscode-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up VSCode"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! is-executable code; then \
		ln -s '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' /usr/local/bin/ || echo-color red "Failed to symlink code" && true; \
	fi
	
	cat $(DOTFILES_DIR)/apps/vscode/vscode-extensions.list | xargs -L1 code --install-extension || echo-color red "Failed to install all the VSCode extensions" && true
endif


vscode-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing VSCode if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "Visual Studio Code.app"); then echo-color yellow "Installing VSCode" && brew install vscode; fi
endif


sublime: sublime-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up Sublime Text"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! is-executable subl; then \
		ln -s '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' /usr/local/bin/ || echo-color red "Failed to symlink subl" && true; \
	fi
endif


sublime-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Sublime Text if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "Sublime Text.app"); then echo-color yellow "Installing Sublime Text" && brew install sublime-text; fi
endif


iterm: iterm-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Importing iTerm color schemes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/apps/iterm/import-color-schemes.sh || echo-color red "Failed to import iTerm color schemes" && true
endif


mamba: miniforge
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mamba in the base conda environment"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable conda && conda install -y mamba -n base -c conda-forge || echo-color red "Failed to install mamba" && true
endif


miniforge: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing miniforge if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable conda || echo-color yellow "Installing miniforge" && brew install miniforge
endif


iterm-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing iTerm if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! (ls /Applications | grep "iTerm.app"); then echo-color yellow "Installing iTerm" && brew install iterm; fi
endif


mopidy: mopidy-install
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Starting up mopidy as a servce"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew services start mopidy || echo-color red "Failed to start mopidy as a service" && true
endif


mopidy-install: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mopidy and ncmpcpp if they do not not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG	
	is-executable mopidy || echo-color yellow "Installing mopidy" && brew install mopidy mopidy-mpd mopidy-spotify
	is-executable ncmpcpp || echo-color yellow "Installing ncmpcpp" && brew install ncmpcpp
endif


###############################################################################
# Default apps 				      					 					      #
###############################################################################

default-apps: duti
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up default apps for various filetypes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	duti -v $(DOTFILES_DIR)/duti/Dutifile || echo-color red "Failed to set default apps" && true
endif


duti: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing duti if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable duti || echo-color yellow "Installing duti" && brew install duti
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

keytab:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Generating keytab for lxplus access"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	ktutil -k ~/.ssh/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3
endif