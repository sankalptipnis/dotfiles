# Things to automate in the setup of a macOS system


## System
Automate the setting of system preferences, in particular
1. Trackpad settings
2. Battery/power settings
3. Software auto-update settings
4. Security settings


## Apps
Automate setup of apps: look into [mackup](https://github.com/lra/mackup).

In particular, need a way to sync settings (and more) for the following apps:
1. Alfred
2. Raycast
3. LaunchBar
4. Adguard
5. LittleSnitch
6. iTerm
7. Sublime Text
8. Sublime Merge
9. BetterTouchTool
10. SteerMouse
11. Bartender
12. Google Drive
13. Fantastical
14. Karabiner Elements
15. Loqseq
16. Mimestream
17. MovistPro
18. Obsidian


## Setup Script
1. Make targets idempotent: Create a file at the end of a step to indicate its completion?
2. Figure out a way to deal with files with passwords in them: look into [git-secret](https://git-secret.io/) & [BlackBox](https://github.com/StackExchange/blackbox)
3. Use a different setup manager: look into Ansible, Nix, and options listed in this [table](https://www.chezmoi.io/comparison-table/)