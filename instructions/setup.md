# How to setup your new macOS system
(instructions are valid as of macOS Monterey)

## Table of contents:
  - [Trackpad](#trackpad)
  - [Keyboard](#keyboard)
  - [Security](#security)
  - [Xcode](#xcode)
  - [Command Line Tools](#command-line-tools)
  - [SSH](#ssh)
  - [Automated Installation](#automated-installation)
  - [System](#system)
  - [Sublime Text](#sublime-text)
  - [Better Touch Tool](#better-touch-tool)
  - [Keyboard Shortcuts](#keyboard-shortcuts)
  - [Chrome and Gmail](#chrome-and-gmail)
  - [Kerberos Access to LXPLUS](#kerberos-access-to-lxplus)
  - [Shpotify](#shpotify)
  - [Remaining Apps Installation](#remaining-apps-installation)
  - [App Setup](#app-setup)

## Trackpad
1. Set trackpad settings:
   1. Point & Click
      *  Disable `Look up & data detectors`
      *  Enable `Tap to click`
      *  Enable `Secondary Click`
      *  Increase `Tracking speed` to two notches below maximum
      *  Change `Click` to `Firm`
      *  Disable `Force Click`
   2. Scroll & Zoom 
      *  Disable `Scroll Direction: Natural`
      *  Enable `Zoom in or out`
      *  Disable `Smart Zoom`
      *  Enable `Rotate`
   3. More Gestures
      *  Enable `Swipe between pages: Scroll left or right with two fingers`
      *  Enable `Swipe between full-screen apps: Scroll left or right with four fingers`
      *  Enable `Notification Centre: Swipe left from the right edge with two fingers`
      *  Enable `Mission Control: Swipe up with four fingers`
      *  Enable `App Expose: Swipe down with four fingers`
      *  Disable `Launchpad`
      *  Disable `Show Desktop`
2. Enable three finger drag \
   System Preferences -> Accessibility -> Pointer Control -> Trackpad Options -> Enable `Enable Dragging: Three finger drag`

## Keyboard
Set keyboard `Input Source` to `British - UK`: System Preferences -> Keyboard -> Input Sources
 
## Security
1. Require password immediately after screensaver starts:\
   System Preferences -> Security & Privacy -> General -> Enable `Require password: Immediately`
2. Turn on FileVault:\
   System Preferences -> Security & Privacy -> FileVault -> `Turn On FileVault`
3. Turn on Firewall:\
   System Preferences -> Security & Privacy -> FileVault -> `Turn On Firewall`

## Xcode
1. Sign into Apple account
2. Install Xcode from the App Store
3. Open XCode and accept the license agreement
4. Open XCode and set the Command Line Tools to "Xcode xx.x.x": Preferences -> Locations -> Locations tab -> Command Line Tools

## Command Line Tools
Install Command Line Tools:
```bash
xcode-select --install
```
## SSH
Copy the private key and the public key to `~/.ssh`.

## Automated Installation
Run the full [automated installation](../README.md) using the [Makefile](../Makefile):
```bash
cd ~
git clone --recurse-submodules https://github.com/sankalptipnis/dotfiles.git
cd dotfiles
make -s all
```
## System
1. Finder
   1. Set column view to default
   2. Configure side bar: Finder (menubar) -> Preferences -> ...
   3. Customise Toolbar
2. Battery
   1. Enable battery percentage in menu bar\
      System Preferences -> Dock & Menu Bar -> Battery -> Enable `Show in Menu Bar`
   2. Set power settings
3. Software Auto-update: System Preferences -> Software Update -> Advanced:
   1. Enable `Check for updates`
   2. Enable `Download new updates when available`
   3. Disable `Insatall macOS updates`
   4. Enable `Insall app updates from the App Store`
   5. Enable `Install system data files and security updates`

## Sublime Text
1. Install `Package Control` from the `Command Palette`
2. `git restore` any changes in `~/Library/Application Support/Sublime Text/Packages/User`

## Better Touch Tool
Import settings from this [file](../apps/btt/triggers/Default.bttpreset).

## Keyboard Shortcuts
Set keyboard shortcuts:
1. macOS keyboard shortcuts: System Preferences -> Keyboard -> Shortcuts
2. AltTab app
3. Raycast (Command + Space)
4. Alfred (Option + Space)
5. Bartender (Command + Option + Control + .)
6. 1Password Mini (Command + Option + P)

## Chrome and Gmail
1.  Sign into Chrome
2.  Set the Gmail website to be the default email app, if required:
    1.  Mail.app -> Preferences -> Default email reader -> Google Chrome.app
    2.  Google Chrome.app -> Privacy and Security -> Site Settings -> Additional Permissions -> Protocol Handlers -> Sites can ask to handle protocols
    3.  Go the the [Gmail website](https://mail.google.com/mail/u/0/#inbox) -> Click on diamond icon on the right of the status bar -> Set "Allow mail.google.com to open all email links?" to Allow
3. Import Reddit Enhancement Suite settings from a backup file in the following [directory](../res/)
4. Set up other extensions

## Kerberos Access to LXPLUS
Create a keytab file containing your password that will be fed to the kinit command in order to obtain a Kerberos ticket. On macOS X (which comes with the Heimdal flavor of Kerberos, and not MIT’s) the command to add a password for CERN’s account is:

```bash
ktutil -k ~/.ssh/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3

(type your password)
```
Alternatively you can use the [Makefile](../Makefile) to create the keytab:

```bash
cd $DOTFILES_DIR
make keytab
```
## Shpotify
shpotify needs to connect to Spotify’s API in order to find music by
name. It is very likely you want this feature!

To get this to work, you first need to sign up (or into) Spotify’s
developer site and [create an *Application*](https://developer.spotify.com/dashboard/applications). Once you’ve
done so, you can find its `Client ID` and `Client Secret` values and
enter them into your shpotify config file at `${HOME}/.shpotify.cfg`.

Be sure to quote your values and don’t add any extra spaces. When
done, it should look like the following (but with your own values):

```bash
CLIENT_ID="abcde12345"
CLIENT_SECRET="12345abcde"
```

## Remaining Apps Installation
Install apps which cannot be installed using Homebrew or mas-cli manually:
- Required Apps 
    1. [Amphetamine Enhancer](https://github.com/x74353/Amphetamine-Enhancer) app
    2. TrashMe 3 helper app
    3. [Video DownloadHelper Companion](https://www.downloadhelper.net/install-coapp) app
- Optional Apps
    1. [Roam Research](https://roamresearch.com/)
    2. Adobe Creative Cloud
    3. Mathematica

## App Setup
Open (and sign into, if required) and configure remaining installed apps.






