# How to setup your new macOS system
(instructions are valid as of macOS Monterey)

**Table of contents**:
  - [Trackpad](#trackpad)
  - [Xcode](#xcode)
  - [Automated Installation](#automated-installation)
  - [System](#system)
  - [Chrome and Gmail](#chrome-and-gmail)
  - [Better Touch Tool](#better-touch-tool)
  - [Steermouse](#steermouse)
  - [iTerm2](#iterm2)
  - [VScode](#vscode)
  - [SSH](#ssh)
  - [Sublime Text](#sublime-text)
  - [Sublime Merge](#sublime-merge)
  - [Kerberos + Keytab Access to LXPLUS](#kerberos--keytab-access-to-lxplus)
  - [Mopidy + ncmpcpp](#mopidy--ncmpcpp)
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
 

## Xcode
1. Sign into Apple account
2. Install Xcode from the App Store


## Automated Installation
1. Install Command Line Tools (CLT) for Xcode
    ```bash
    make clt
    ```
2. Run the full [automated installation](../README.md) using the [Makefile](../Makefile)   
    ```bash
    make all
    ```

## System
1. Finder
   1. Set column view to default
   2. Configure side bar
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


## Security
Set up security: **TODO**

## Chrome and Gmail
1.  Sign into Chrome
2.  Set the Gmail website to be the default email app
    1.  Mail.app -> Preferences -> Default email reader -> Google Chrome.app
    2.  Google Chrome.app -> Privacy and Security -> Site Settings -> Additional Permissions -> Protocol Handlers -> Sites can ask to handle protocols
    3.  Go the the [Gmail website](https://mail.google.com/mail/u/0/#inbox) -> Click on diamond icon on the right of the status bar -> Set "Allow mail.google.com to open all email links?" to Allow


## Better Touch Tool
Set up better touch tool or import settings from [file](../apps/btt/Default.bttpreset).


## Steermouse
Set up steermouse or import settings from [file](../apps/steermouse/Default.smsetting_app).


## iTerm2
1. Set up iTerm
2. Restore [profile](../apps/iterm/Profiles/Default+.json)


## VScode
 1. Set Color Theme to Dark+: Cmd + Shift + P -> Preferences: Color Theme -> Dark+
 2. Update using saved [settings](../apps/vscode/settings.json) and [keybindings](../apps/vscode/keybindings.json) as required


## SSH
Copy the private keyand the public key to `~/.ssh`.


## Sublime Text
1.  Set up Sublime Text
    1.  Install extensions from [list](../apps/sublime/text/sublime_text-extensions.list)
    2.  Update using saved [settings](../apps/sublime/text/Settings/User) as required
    3.  Set up remote usage: [RemoteSubl](https://github.com/randy3k/RemoteSubl)


## Sublime Merge
1. Restore the color scheme:
   * The look of the Sublime Merge interface is controlled by *themes*. The term theme refers strictly to the look of the UI – buttons, the commit list, location bar, command palette and so forth. 
   * The highlighting of diffs is controlled by a combination of *color schemes* and syntax definitions.
   * To change the color scheme:
       - There are three settings files that you need to amend and one file you need to create inside of your Sublime Merge User package, which you can find by using the Preferences > Browse Packages command.
       - The file you need to create is [`MK.sublime-color-scheme`](../apps/sublime/merge/MK.sublime-color-scheme) which holds the custom Monokai color scheme (henceforth referred to as **MK**).
       - The files you want to amend are (you are extending the default Merge Dark color scheme by doing this):
           - Commit Message - Merge Dark.sublime-settings
           - Diff - Merge Dark.sublime-settings
           - File Mode - Merge Dark.sublime-settings
       - Add the following to the above files:
         ```json
         {
           "color_scheme": "MK.sublime-color-scheme"
         }
         ```
         This *extends* the **Merge Dark** theme to use **MK** as the color scheme.
   * To change the theme, you need to extend the *Merge Dark* theme appropriately:\
     Create [`Merge Dark.sublime-theme`](../apps/sublime/merge/Merge%20Dark.sublime-theme) in the folder containing `MK.sublime-color-scheme` and add the following to it:
       ```json
       {
           "extends": "Merge.sublime-theme",
           "variables":
           {
               "dark_gray-lightest": "rgb(23, 23, 20)", // commits
               "dark_gray-light": "rgb(35, 35, 33)", // locations
               "dark_gray-medium": "rgb(12, 12, 10)", // header
               "repository_tab_bar_bg": "rgb(35, 35, 33)", // tabs
           },
       }
       ```
       This appropriately changes the UI elements of Sublime Merge.


## Kerberos + Keytab Access to LXPLUS
Make a keytab file with your encrypted password. This step is to create a keytab file containing your password that will be fed to the kinit command in order to obtain a Kerberos ticket. On macOS X (which comes with the Heimdal flavor of Kerberos, and not MIT’s) the command to add a password for CERN’s account is:
```bash
$ ktutil -k ~/.ssh/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3
(type your password)
```
Alternatively you can use the [Makefile](../Makefile) to create the keytab:
```bash
$ make keytab
```

## Mopidy + ncmpcpp
Fill in your Spotify username and password, and the client id and secret in the file `~/.config/mopidy.conf/mopidy`.

Client id and secret can be obtained [here](https://mopidy.com/ext/spotify/) on validating your Spotify login details.


## spotifyd + Spotify TUI
Set up spotifyd & Spotify TUI as described [here](misc.md#spotifyd--spotify-tui), if required.


## Remaining Apps Installation
Install apps which cannot be installed using Homebrew or mas-cli manually:
1. Required Apps 
     1. Roam Research
2. Optional Apps
     1. Adobe Creative Cloud
     2. Mathematica


## App Setup
1. Set up Google Drive
2. Set up Alfred
3. Set up Raycast
4. Set up Dato
5. Set up menu bar using Bartender
6. Set up Safari
7. Set up Logseq
8. Set up Fantastical









