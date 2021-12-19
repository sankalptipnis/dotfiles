## Requirements
   - [x] Ask for password once upfront
   - [x] Non-interactive Homebrew installation
   - [x] Install apps and binaries using the Brewfile
   - [x] Set up brew-installed bash 
   - [x] Update macOS defaults
   - Copy dotfiles + other files to appropriate locations
     - Bash
       - [x] .bash_profile
       - [x] .bashrc
       - [x] .bash_prompt
       - [x] .path
       - [x] .functions
       - [x] .aliases
       - [x] .exports
     - Git
       - [x] .gitconfig
     - SSH
       - [x] config
       - [x] public key
       - [x] private key
       - [x] krb5.conf
     - XQuartz
       - [x] .Xdefualts
     - Hammerspoon
       - [x]init.lua
   - [x] Import iTerm color schemes
   - [x] Install VSCode extensions
   - [x] Set up conda



1. review macos defaults + touchpad

Resources:
1. touchpad - https://github.com/escrichov/dotfiles/blob/master/install/macosx/osx-user-defaults.sh
2. defaults: https://github.com/escrichov/dotfiles/blob/master/install/macosx/osx-system-defaults.sh https://github.com/escrichov/dotfiles/blob/master/install/macosx/osx-user-defaults.sh 


defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1

defaults read com.apple.AppleMultitouchTrackpad

defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 0

ActuateDetents = 1;
Clicking = 1;
DragLock = 0;
Dragging = 0;
FirstClickThreshold = 2;
ForceSuppressed = 0;
HIDScrollZoomModifierMask = 0;
SecondClickThreshold = 2;
TrackpadCornerSecondaryClick = 0;
TrackpadFiveFingerPinchGesture = 0;
TrackpadFourFingerHorizSwipeGesture = 2;
TrackpadFourFingerPinchGesture = 0;
TrackpadFourFingerVertSwipeGesture = 0;
TrackpadHandResting = 1;
TrackpadHorizScroll = 1;
TrackpadMomentumScroll = 1;
TrackpadPinch = 1;
TrackpadRightClick = 1;
TrackpadRotate = 1;
TrackpadScroll = 1;
TrackpadThreeFingerDrag = 1;
TrackpadThreeFingerHorizSwipeGesture = 0;
TrackpadThreeFingerTapGesture = 2;
TrackpadThreeFingerVertSwipeGesture = 0;
TrackpadTwoFingerDoubleTapGesture = 1;
USBMouseStopsTrackpad = 0;
UserPreferences = 1;
version = 12;