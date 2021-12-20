# Debug mode only prints to console, and does not run any commands
# DEBUG = TRUE

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

GREEN_ECHO_PREFIX = '\033[92m'
GREEN_ECHO_SUFFIX = '\033[0m'

.PHONY: all sudo core brew bash chsh git brew-packages packages cask-apps mas-apps \
        link macos-defaults dock link app-setup vscode sublime iterm hammerspoon conda \
	mopidy default-apps clt

print:
ifndef DEBUG
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ NOT DEBUG MODE"$(GREEN_ECHO_SUFFIX)
else
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ DEBUG MODE"$(GREEN_ECHO_SUFFIX)
endif

default: all

all: sudo core link macos-defaults packages dock app-setup default-apps

core: brew bash git stow

packages: brew-packages cask-apps mas-apps

macos-defaults: sudo
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting sensible macOS defaults"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/macos/defaults.sh
endif

dock:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Organising the dock"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/macos/dock.sh
endif

stow: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing GNU Stow"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable stow || brew install stow
endif

sudo:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Making sudo passwordless"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if [ ! -f /etc/sudoers.d/sankalptipnis ]; then \
		sudo cp $(DOTFILES_DIR)/macos/sudo/sankalptipnis /etc/sudoers.d; \
	fi
endif

sudo-revert:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Making sudo require password"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if [ -f /etc/sudoers.d/sankalptipnis ]; then \
		sudo rm -f /etc/sudoers.d/sankalptipnis; \
	fi
endif

########### TEST TARGETS ###########
karabiner: sudo
	brew install karabiner-elements

mactex: sudo
	brew install mactex-no-gui

miniforge: sudo
	brew install miniforge

xquartz: sudo
	brew install xquartz
####################################

link: stow
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Backing up old dotfiles and linking new dotfiles"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	find $(DOTFILES_DIR) -name '.DS_Store' -type f -delete

	@echo -e $(GREEN_ECHO_PREFIX)"* Setting up bash dotfiles"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/bash); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/bash; stow -t $(HOME) .

	for FILE in $$(\ls -A $(DOTFILES_DIR)/bash_helpers); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/bash_helpers; stow -t $(HOME) .

	@echo -e $(GREEN_ECHO_PREFIX)"* Setting up git dotfiles"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/git); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/git; stow -t $(HOME) .

	@echo -e $(GREEN_ECHO_PREFIX)"* Setting up XQuartz dotfiles"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/xquartz); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/xquartz; stow -t $(HOME) .

	@echo -e $(GREEN_ECHO_PREFIX)"* Setting up Kerberos config"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/kerberos); do if [ -f $(KERBEROS_DIR)/$$FILE -a ! -h $(KERBEROS_DIR)/$$FILE ]; then \
		sudo mv -v $(KERBEROS_DIR)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/kerberos; sudo stow -t $(KERBEROS_DIR) .
	
	@echo -e $(GREEN_ECHO_PREFIX)"* Setting up SSH config"$(GREEN_ECHO_SUFFIX)
	mkdir -p $(SSH_DIR)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/ssh); do if [ -f $(SSH_DIR)/$$FILE -a ! -h $(SSH_DIR)/$$FILE ]; then \
		mv -v $(SSH_DIR)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/ssh; stow -t $(SSH_DIR) .

	mkdir -p $(CONFIG_DIR)
	
	@echo -e $(GREEN_ECHO_PREFIX)"* Setting up mopidy config"$(GREEN_ECHO_SUFFIX)
	mkdir -p $(MOPIDY_DIR)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/mopidy); do if [ -f $(MOPIDY_DIR)/$$FILE -a ! -h $(MOPIDY_DIR)/$$FILE ]; then \
		mv -v $(MOPIDY_DIR)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/mopidy; stow -t $(MOPIDY_DIR) .

	@echo -e $(GREEN_ECHO_PREFIX)"* Setting up ncmpcpp config"$(GREEN_ECHO_SUFFIX)
	mkdir -p $(NCMPCPP_DIR)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/ncmpcpp); do if [ -f $(NCMPCPP_DIR)/$$FILE -a ! -h $(NCMPCPP_DIR)/$$FILE ]; then \
		mv -v $(NCMPCPP_DIR)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/ncmpcpp; stow -t $(NCMPCPP_DIR) .
endif

unlink: stow
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Unlinking dotfiles and restoring backups if they exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	
	cd $(DOTFILES_DIR)/bash; stow --delete -t $(HOME) .
	
	cd $(DOTFILES_DIR)/bash_helpers; stow --delete -t $(HOME) .
	
	cd $(DOTFILES_DIR)/git; stow --delete -t $(HOME) .

	cd $(DOTFILES_DIR)/xquartz; stow --delete -t $(HOME) .

	cd $(DOTFILES_DIR)/ssh; stow --delete -t $(SSH_DIR) .

	cd $(DOTFILES_DIR)/mopidy; stow --delete -t $(MOPIDY_DIR) .

	cd $(DOTFILES_DIR)/ncmpcpp; stow --delete -t $(NCMPCPP_DIR) .
	
	@echo -e $(GREEN_ECHO_PREFIX)"* Unlinking bash dotfiles"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/bash); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

	for FILE in $$(\ls -A $(DOTFILES_DIR)/bash_helpers); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

	@echo -e $(GREEN_ECHO_PREFIX)"* Unlinking git dotfiles"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/git); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

	@echo -e $(GREEN_ECHO_PREFIX)"* Unlinking XQuartz dotfiles"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/xquartz); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

	@echo -e $(GREEN_ECHO_PREFIX)"* Unlinking SSH config"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/ssh); do if [ -f $(SSH_DIR)/$$FILE.bak ]; then \
		mv -v $(SSH_DIR)/$$FILE.bak $(SSH_DIR)/$${FILE%%.bak}; fi; done

	@echo -e $(GREEN_ECHO_PREFIX)"* Unlinking mopidy config"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/mopidy); do if [ -f $(MOPIDY_DIR)/$$FILE.bak ]; then \
		mv -v $(MOPIDY_DIR)/$$FILE.bak $(MOPIDY_DIR)/$${FILE%%.bak}; fi; done

	@echo -e $(GREEN_ECHO_PREFIX)"* Unlinking ncmpcpp config"$(GREEN_ECHO_SUFFIX)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/ncmpcpp); do if [ -f $(NCMPCPP_DIR)/$$FILE.bak ]; then \
		mv -v $(NCMPCPP_DIR)/$$FILE.bak $(NCMPCPP_DIR)/$${FILE%%.bak}; fi; done
endif

brew:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew if it does not exist"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
endif

bash: BASH := $(HOMEBREW_PREFIX)/bin/bash
bash: SHELLS := /private/etc/shells
bash: sudo brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing bash"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 && \
		echo $(BASH) | sudo tee -a $(SHELLS) && \
		sudo chsh -s $(BASH) $$(id -un); \
	fi
endif

git: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing git"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew install git
endif

brew-packages: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew packages"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Brewfile || echo-colour red " Failed to install all the Homebrew packages" && true
endif

cask-apps: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing Homebrew Cask apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	brew bundle --file=$(DOTFILES_DIR)/homebrew/Caskfile || echo-colour red " Failed to install all the Homebrew Cask apps" && true
endif

mas-apps: brew
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing macOS App Store apps"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable mas && brew bundle --file=$(DOTFILES_DIR)/homebrew/Masfile || echo-colour red " Failed to install all the macOS App Store apps" && true
endif

app-setup: vscode sublime iterm hammerspoon conda mopidy

vscode:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up VSCode"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable code || ln -s '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' /usr/local/bin/
	cat $(DOTFILES_DIR)/apps/vscode/vscode-extensions.list | xargs -L1 code --install-extension
endif

sublime:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up Sublime Text"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable subl || ln -s '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' /usr/local/bin/
endif

iterm:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up iTerm"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	. $(DOTFILES_DIR)/apps/iterm/import-color-schemes.sh
endif

hammerspoon: HAMMERSPOON_DIR := $(HOME)/.hammerspoon
hammerspoon:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up Hammerspoon"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	mkdir -p $(HAMMERSPOON_DIR)
	for FILE in $$(\ls -A $(DOTFILES_DIR)/apps/hammerspoon); do if [ -f $(HAMMERSPOON_DIR)/$$FILE -a ! -h $(HAMMERSPOON_DIR)/$$FILE ]; then \
		mv -v $(HAMMERSPOON_DIR)/$$FILE{,.bak}; fi; done
	cd $(DOTFILES_DIR)/apps/hammerspoon; stow -t $(HAMMERSPOON_DIR) .
endif

conda:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up conda"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	conda init bash
endif

mopidy:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Starting up mopidy as a servce"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable mopidy && brew services start mopidy || echo-colour red " Failed to start mopidy as a service" && true
endif

default-apps:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Setting up default apps for various filetypes"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable duti && duti -v $(DOTFILES_DIR)/duti/Dutifile || echo-colour red " Failed to set default apps" && true
endif

mamba:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing mamba in the base conda environment"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	is-executable conda && conda install mamba -n base -c conda-forge || echo-colour red " Failed to install mamba" && true
endif

clt:
	@echo -e $(GREEN_ECHO_PREFIX)"\[._.]/ Installing XCode Command Line Tools"$(GREEN_ECHO_SUFFIX)
ifndef DEBUG
	xcode-select --install
endif