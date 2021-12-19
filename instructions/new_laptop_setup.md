# How to setup your new Macbook
1. Sign into Apple account
2. Install XCode from the App Store
3. Install Command Line Tools (CLT) for Xcode
    ```bash
    xcode-select --install
    ```
4. Install Homebrew
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
    ``` 
5. Install Homebrew apps and binaries
   1. Update brew
       ```bash
       brew update
       ```
   2. Install everything in [Brewfile](../homebrew/Brewfile), [Caskfile](../homebrew/Caskfile) and [Masfile](../homebrew/Masfile)
       ```bash
       brew bundle
       ```
   3. Cleanup
       ```bash
       brew cleanup
       brew cask cleanup
6. Set up brew-installed bash 
   1. Switch to using as default shell
       ```bash
       if ! grep -q "$(brew --prefix)/bin/bash" /etc/shells; then
            echo "$(brew --prefix)/bin/bash" | sudo tee -a /private/etc/shells;
            chsh -s /usr/local/bin/bash;
       fi;
       ```
   2. Copy dotfiles to the `HOME` directory:
      * `.bash_profile`
      * `.bashrc`
      * `.bash_prompt`
      * `.path`
      * `.functions`
      * `.aliases`
      * `.exports`
   3. Add any required PATH exports to the `.path` file:
      1. GNU Utils
         ```bash
         export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
         export PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"
         export PATH="$(brew --prefix)/opt/gnu-indent/libexec/gnubin:$PATH"
         export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
         export PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
         export PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
         export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"  
         ```
   4. Set up [bash](https://superuser.com/questions/288438/bash-completion-for-commands-in-mac-os-x) [completion](https://blog.magepsycho.com/bash-completion-mac-os-x/)
7. Load Hammerspoon [config](../apps/hammerspoon/init.lua)
8. Set sensible macOS defaults: Run [script](../macos/defaults.sh)
9. Sign into Chrome
10. Set the Gmail website to be the default email app
    1.  Mail.app -> Preferences -> Default email reader -> Google Chrome.app
    2.  Google Chrome.app -> Privacy and Security -> Site Settings -> Additional Permissions -> Protocol Handlers -> Sites can ask to handle protocols
    3.  Go the the [Gmail website](https://mail.google.com/mail/u/0/#inbox) -> Click on diamond icon on the right of the status bar -> Set "Allow mail.google.com to open all email links?" to Allow
11. Sign into 1Password
12. Set up Better Touch Tool: Import [settings file](../apps/btt/Default.bttpreset)
13. Set up Steermouse: Import [settings file](../apps/steermouse/Default.smsetting_app)
14. Set up iTerm2
    1. Import color schemes
        ```bash
        git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git
        cd iTerm2-Color-Schemes
        tools/import-scheme.sh -v schemes/*
        cd ..
        rm -rf iTerm2-Color-Schemes 
        ```
     1. Restore [profile](../apps/iterm/Profiles/Default.json)
15. Set up git
    1. Copy [.gitconfig](../git/.gitconfig) to the HOME directory 
16. Set up VSCode
    1. Set Color Theme to Dark+: Cmd + Shift + P -> Preferecnes: Color Theme -> Dark+
    2. Install extensions from [list](../apps/vscode/vscode-extensions.list)
        ```bash
        cat vscode-extensions.list | xargs -L 1 code --install-extension
        ```     
    3. Update using saved [settings] and [keybindings] as required
17. Set up Sublime Text
    1.  Install extensions from [list](../apps/sublime/text/sublime_text-extensions.list)
    2.  Update using saved [settings](../apps/sublime/text/Settings/User) as required
    3.  Set up remote usage: [RemoteSubl](https://github.com/randy3k/RemoteSubl)
    4.  Make shortcut
         ```bash
         ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
         ``` 
18. Set up Sublime Merge
    1.  [Restore color scheme](../apps/sublime/merge/sublime_merge_colors.md)
19. Set up conda/mamba
    1.  Install miniforge (should already have be done as part of the Homebrew Cask app installatons)  
    2.  Set up conda installation:
         ```bash
         conda init "$(basename "${SHELL}")"
         ```
    3.  Install mamba in the base environment:
         ```bash
         conda install mamba -n base -c conda-forge
         ```
    4.  Create enviroments  
    5.  [Install tensorflow](https://betterprogramming.pub/installing-tensorflow-on-apple-m1-with-new-metal-plugin-6d3cb9cb00ca)
20. Set up SSH
    1.  Copy the [config](../ssh/config), the [private key](../ssh/id_ed25519) and the [public key](../ssh/id_ed25519) to ~/.ssh
21. Set up Kerberos + Keytab
    1. Based on https://frankenthal.dev/post/ssh_kerberos_keytabs_macos/
    2. This step should have already been done as part of the Brewfile installation. If not, install the correct SSH binary which supports GSSAPI authentication (from https://github.com/rdp/homebrew-openssh-gssapi).

        ```bash
        $ brew tap rdp/homebrew-openssh-gssapi

        $ brew install rdp/homebrew-openssh-gssapi/openssh-patched --with-gssapi-support
        ```
        It is **NOT** necessary to follow the instructions on the terminal screen after the installation.
    3. Place the `krb5.conf` [file](../kerberos/krb5.conf) in `/etc/`.
    4. This step should have already been done as part of the SSH setup. If not, edit the `~/.ssh/config` file to include GSSAPI authentication for LXPLUS.
    5. Make a keytab file with your encrypted password. This step is to create a keytab file containing your password that will be fed to the kinit command in order to obtain a Kerberos ticket. On macOS X (which comes with the Heimdal flavor of Kerberos, and not MIT’s) the command to add a password for CERN’s account is:

        ```bash
        ktutil -k ~/.ssh/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3
        (type your password)
        ```
    6. This step should have already been done as part of a previous LXPLUS keytab creation. If not, make your keytab file when logged in to one of the LXPLUS machines:

        ```bash
        ktutil 
        addent -password -p user@CERN.CH -k 3 -e arcfour-hmac-md5
        (type your password)
        wkt keytab
        quit
        ```
    7. This step should have already been done as part of the dotfiles setup. If not, add the follwing command to `~/.bash_profile`:

        ```bash
        kinit -kt ~/.ssh/keytab stipnis@CERN.CH
        ```

        This will grant you Kerberos tickets without having to type your password
22. Set up XQuartz
    1. Add colour
        Copy the `.Xdefaults` [file](../xquartz/.Xdefaults) with the following contents into the `HOME` directory:

         ```
         xterm*Background:               black
         xterm*cursorColor:              white
         xterm*Foreground:               white
         ```
23. Install [remaining apps](remaining_apps.md)
24. Set up Alfred
    1. Restore ["Open Playground" script](../apps/alfred/Open%20Playgoround.alfredworkflow)
    2. Restore ["Open Idea Pad" script](../apps/alfred/Open%20Idea%20Pad.alfredworkflow)
25. Sign into up Firefox
26. Sign into Outlook
27. Sign into Skype




