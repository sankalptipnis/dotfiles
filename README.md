


              $$\             $$\      $$$$$$\  $$\ $$\                     
              $$ |            $$ |    $$  __$$\ \__|$$ |                    
         $$$$$$$ | $$$$$$\  $$$$$$\   $$ /  \__|$$\ $$ | $$$$$$\   $$$$$$$\ 
        $$  __$$ |$$  __$$\ \_$$  _|  $$$$\     $$ |$$ |$$  __$$\ $$  _____|
        $$ /  $$ |$$ /  $$ |  $$ |    $$  _|    $$ |$$ |$$$$$$$$ |\$$$$$$\  
        $$ |  $$ |$$ |  $$ |  $$ |$$\ $$ |      $$ |$$ |$$   ____| \____$$\ 
    $$\ \$$$$$$$ |\$$$$$$  |  \$$$$  |$$ |      $$ |$$ |\$$$$$$$\ $$$$$$$  |
    \__| \_______| \______/    \____/ \__|      \__|\__| \_______|\_______/ 
                                                                            
                                                                                                                                
My dotfiles for macOS. Feel free to use at your own risk. Your mileage may vary.

## Overview
* Installs Homebrew
* Symlinks or copies configuration files
* Sets sensible macOS defaults
* Installs binaries/apps/extensions/packages
* Configures the dock
* Sets default apps for select filetypes

## Requirements
* Xcode:
   - Sign into App Store
   - Install XCode
   - Open XCode and accept the license agreement
   
## Installation
The automated installation is managed by a GNU [Makefile](Makefile). To install everything, run:
```bash
cd ~
git clone --recurse-submodules https://github.com/sankalptipnis/dotfiles.git
cd dotfiles
make -s all
```
## What does a full installation actually do?
1. Makes sudo passwordless
2. Installs the core binaries: [Homebrew](https://brew.sh/) and [Bash](https://www.gnu.org/software/bash/)
3. Links/copies the configuration files to appropriate locations
4. Sets sensible macOS defaults defined [here](macos/defaults.sh)
5. Installs binaries/apps/extensions/packages: 
   1. Binaries, apps, fonts & quicklook plugins defined in [Brewfile](homebrew/Brewfile) using Homebrew
   2. App store apps defined in [Masfile](homebrew/Masfile) using [mas](https://github.com/mas-cli/mas)
   3. Installs [mamba](https://github.com/mamba-org/mamba) into the base conda environment
   4. Creates conda environments defined in the [`envs` directory](conda/envs/) using mamba
   5. Installs VSCode extensions defined in [Codefile](vscode/extensions/Codefile)
   6. Imports iTerm color profiles
6. Configures the dock using [Dockutil](https://github.com/kcrawford/dockutil): configuration is defined [here](macos/dock.sh)
7.  Sets default apps for select filetypes using [Duti](https://github.com/moretension/duti): configuration is defined in [Dutifile](duti/Dutifile)

 
PS : For full instructions (including all the manual steps + the above automated installation) to set up a new macOS system, see [here](instructions/setup.md).

