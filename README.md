# My dotfiles for macOS
Feel free to use at your own risk. Your mileage may vary.

## Overview
* Installs Homebrew
* Symlinks or copies configuration files
* Sets sensible macOS defaults
* Installs binaries and apps
* Configures the dock
* Configures select apps
* Sets default apps for select filetypes

## Requirements
* Xcode Command Line Tools (CLT) : to install run 
    ```bash
    xcode-select --install
    ```

## Installation
Installation is managed by a GNU [Makefile](Makefile). To install everything, clone this repository and run 
```bash
$ make all
```
from within it.

## What does a full installation actually do?
1. Makes sudo passwordless for the duration of the installation
2. Installs the core binaries: [Homebrew](https://brew.sh/), [Git](https://git-scm.com/) and [GNU Stow](https://www.gnu.org/software/stow/)
3. Stows or copies the following configuration files to appropriate locations:
   1. Bash
   2. Git
   3. SSH
   4. XQuartz
   5. Kerberos
   6. Mopidy and NCMPCPP
   7. Spotifyd
   8. Hammerspoon
4. Sets sensible macOS defaults: defined [here](macos/defaults.sh)
5. Installs apps using [Homebrew](https://brew.sh/) and [`mas-cli`](https://github.com/mas-cli/mas)
   1. Binaries: defined in [Brewfile](homebrew/Brewfile)
   2. Apps, fonts & quicklook plugins: defined in [Caskfile](homebrew/Caskfile)
   3. App store apps: defined in [Masfile](homebrew/Masfile) (`mas-cli` is installed as part of this step)
6. Removes the quarantine attribute from the installed quicklook plugins
7. Configures the dock using [Dockutil](https://github.com/kcrawford/dockutil): configuration is defined [here](macos/dock.sh)
8. Configures select apps:    
   1. VSCode:
      * Installs extensions: defined [here](apps/vscode/vscode-extensions.list) 
      * Creates a symlink to be able to open VSCode using `code` on the command line
   2. iTerm: Installs loads of color schemes
   3. Sublime Text: Creates a symlink to be able to open Sublime Text using `subl` on the command line
   4. Sublime Merge: Creates a symlink to be able to open Sublime Merge using `smerge` on the command line
   5. mamba: Installs mamba into the base miniforge environment
   6. mopidy: Starts mopidy as a service
9.  Sets default apps for select filetypes using [Duti](https://github.com/moretension/duti): defined in [Dutifile](duti/Dutifile)



