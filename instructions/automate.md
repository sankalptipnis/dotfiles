# Things to automate in the setup of a macOS system

## System
Automate the setting of system preferences, in particular
1. Trackpad settings
2. Battery/power settings
3. Software auto-update settings
4. Security settings
5. macOS Keyboard shortcuts (iCloud?)


## Apps
Automate setup of apps: look into [mackup](https://github.com/lra/mackup).

In particular, need a way to sync settings (and more) for the following apps:
1. Alfred (automate native backup and restore)
2. Raycast (automate native backup and restore)
3. iTerm (automate native backup and restore)
4. Sublime Text (settings located in `${HOME}/Library/Application Support/Sublime Text/Packages/User`)
5. Sublime Merge (settings located in `${HOME}/Library/Application Support/Sublime Merge/Packages/User`)
6. Karabiner Elements (automate native backup and restore)
7. macOS Shortcuts (iCloud?)


## Setup Script
1. Figure out a way to deal with files with passwords in them: look into [git-secret](https://git-secret.io/) & [BlackBox](https://github.com/StackExchange/blackbox)
2. Use a different setup manager: look into Ansible, Nix, and options listed in this [table](https://www.chezmoi.io/comparison-table/)


# Bash Tab Completion
1. Investigate [fzf-obc](https://github.com/rockandska/fzf-obc)