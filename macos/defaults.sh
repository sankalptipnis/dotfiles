#!/usr/bin/env bash

# EXAMPLES:
# Read: defaults read NSGlobalDomain NSAutomaticWindowAnimationsEnabled
# Write: defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
# Delete: defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled
 
COMPUTER_NAME="ST-MBP"

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars
# Possible values: `WhenScrolling`, `Automatic` and `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -int 0

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Use column view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Show the ~/Library folder
xattr -d com.apple.FinderInfo ~/Library 2>/dev/null
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

###############################################################################
# Screenshots                                                                 #
###############################################################################

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Dock, Mission Control, and hot corners                                      #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Hide and show the dock faster
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.7

# Disable recent apps in the dock
defaults write com.apple.dock show-recents -bool false

# Set the icon size of Dock items to 46 pixels
defaults write com.apple.dock tilesize -int 46

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool true

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
defaults write com.apple.dock expose-group-by-app -bool false

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Bottom left screen corner → Mission Control
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0

# Bottom right screen corner → Show Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Calculator                  												  #
###############################################################################

# Open in scienfific view 
defaults write com.apple.calculator ViewDefaultsKey -string "Scientific"

###############################################################################
# Disk Utility                												  #
###############################################################################

defaults write com.apple.DiskUtility "OperationProgress DetailsVisible" -bool true
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true

###############################################################################
# Activity Monitor                											  #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show CPU usage tab on opening
defaults write com.apple.ActivityMonitor SelectedTab -int 0

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# TextEdit                  												  #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Terminal 				                                                      #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Disable the annoying line marks
defaults write com.apple.Terminal ShowLineMarks -int 0

###############################################################################
# iTerm2 				                                                      #
###############################################################################

# Use custom directory to load settings
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Path to directory containing the settings
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/dotfiles/iterm/settings"

# Dont ask on exit if changes exist
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true

# Save changes when quitting iTerm (0 -> When quitting, 1 -> Manually, 2 -> Automatically)
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 0

# Auto-hide the scrollbars
defaults write com.googlecode.iterm2 HideScrollbar -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"cfprefsd" \
	"Dock" \
	"Photos" \
	"TextEdit" \
	"Disk Utility" \
	"Calculator" \
	"SystemUIServer" \
	"iTerm2" \
	"Finder"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
