# Useful information for setting up a macOS system
(information is valid as of macOS Monterey)

## Table of contents:

  - [Shell](#shell)
  - [Sudo](#sudo)
  - [Spotifyd and Spotify TUI](#spotifyd-and-spotify-tui)
  - [XQuartz](#xquartz)
  - [Duti](#duti)
  - [LaTeX](#latex)
  - [VSCode](#vscode)
  - [CERN](#cern)
    - [Renew Grid Certificate](#renew-grid-certificate)
    - [Kerberos Access to LXPLUS](#kerberos-access-to-lxplus)
  - [Markdown Extensions](#markdown-extensions)
    - [VSCode](#vscode-1)
    - [Sublime Text](#sublime-text)
  - [Disk Usage Apps](#disk-usage-apps)


## Shell
1. Get current shell:
    ```bash
    dscl . -read ~/ UserShell
    ```
2. Add (e.g. /usr/local/bin/bash) to list of approved shells (part of automated installation):
    ```bash
    echo /usr/local/bin/bash | sudo tee -a /private/etc/shells
    ```
3. Change default shell for the current user (to e.g. /usr/local/bin/bash) (part of automated installation)
    ```bash
    sudo chsh -s /usr/local/bin/bash $(id -un)
    ```

## Sudo
1. Make sudo passwordless for username `sankalptipnis` (part of automated installation):
   Add file (e.g. `sudoers`) to `/etc/sudoers.d` containing "sankalptipnis ALL=(ALL) NOPASSWD:ALL":
    ```bash
    echo "$(id -un) ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/sudoers
    ```

## Spotifyd and Spotify TUI
(based on https://jonathanchang.org/blog/setting-up-spotifyd-on-macos/)
1. Install spotifyd (part of automated installation):
    ```bash
    brew install spotifyd
    ```
2. Create a config file `~/.config/spotifyd/spotifyd.conf` with at least the following contents (part of automated installation):
    ```bash
    [global]
    # Your Spotify account name.
    username = "sankalptipnis"

    # Your Spotify account password.
    password = ""

    # How this machine shows up in Spotify Connect.
    device_name = "spotifyd"
    device_type = "computer"

    # Various playback options. Tweak these if Spotify is too quiet.
    bitrate = 320
    volume_normalisation = true
    normalisation_pregain = -10

    # These need to be set, but don't need to be changed.
    backend = "portaudio"
    mixer = "PCM"
    volume_controller = "softvol"
    zeroconf_port = 1234
    ```
3. Fill out your Spotify password into the file from step 2
4. Start spotifyd:
    ```bash
    brew services start spotifyd
    ```
5. To test that spotifyd is working, open the official Spotify client on your phone or laptop, and confirm that there’s a new device in Spotify Connect:
   
    ![](images/spotify.png)
   
6. Install Spotify TUI (part of automated installation):
    ```bash
    brew install spotify-tui
    ```
7. Follow the instructions to connect to Spotify's API which will be displayed when you first run Spotify TUI:
    ```bash
    spt
    ```
    The instructions will be along the following lines:
   1. Go to the Spotify dashboard
   2. Click Create an app
   3. You now can see your Client ID and Client Secret
   4.  Now click Edit Settings
   5.  Add http://localhost:8888/callback to the Redirect URIs
   6.  Scroll down and click Save
   7.  You are now ready to authenticate with Spotify!
   8.  Go back to the terminal
   9.  Run spt
   10. Enter your Client ID
   11. Enter your Client Secret
   12. Press enter to confirm the default port (8888) or enter a custom port
   13. You will be redirected to an official Spotify webpage to ask you for permissions.
   14. After accepting the permissions, you'll be redirected to localhost. If all goes well, the redirect URL will be parsed automatically and now you're done. If the local webserver fails for some reason you'll be redirected to a blank webpage that might say something like "Connection Refused" since no server is running. Regardless, copy the URL and paste into the prompt in the terminal.

8. Re-run Spotify TUI, press d, and select the `spotifyd` device

9.  [OPTIONAL] Use keychain to store Spotify password for spotifyd:
    1. Remove the "password" tag from the file `~/.config/spotifyd/spotifyd.conf`
    2. Add the following tag to the same file `~/.config/spotifyd/spotifyd.conf`:
        ```bash
        # You'll be using the macOS keychain to specify your password.
        use_keyring = true
        ```
    3. Add your Spotify password to the system password manager, keychain:
        ```bash
        security add-generic-password -s spotifyd -D rust-keyring -a sankalptipnis -w <your password>
        ```

## XQuartz
1. Add colour by adding an `.Xdefaults` file with the following contents into the `HOME` directory (part of automated installation):
    ```
    xterm*Background:               black
    xterm*cursorColor:              white
    xterm*Foreground:               white
    ```

## Duti
1. Get default application information for e.g. jpg files:
    ```bash
    duti -x jpg 
    ```

## LaTeX
1. Compile command:
	```bash
	cd build
	latexmk --output-directory=. -pdflua -shell-escape ../source/hello.tex
	```
2. Jump from the pdf to source code:
   ```
   Shift + Cmd + Click	
   ```
3. Jump from the source code to the pdf:
    ```
    VSCode: Cmd + Option + j    
    Sublime Text: Cmd + l; j
    ```

## VSCode
1. Save list of installed extensions
    ```bash
    code --list-extensions > vscode-extensions.list
    ```

## CERN

### Renew Grid Certificate
(based on https://www.sdcc.bnl.gov/information/getting-started/installing-your-grid-certificate and https://alice-doc.github.io/alice-analysis-tutorial/start/cert.html)
1. Request a new grid user certificate from [here](https://ca.cern.ch/ca/)
2. Set a grid password (Recommended: Use the same password as for the previous certificate)
3. Download the certificate
4. Open Keychain Access
5. Drag the certificate into Keychain Access to install it
6. Double click the certificate in Keychain Access, open the "Trust" tab and set to "When using this certificate -> Always Trust" 
7. Click the > button on the left of the certificate in Keycahain Access, double click the private key that opens up, and set "Allow all applications to access this item" in the "Access Control" tab
8. Copy the grid cerificate to any remote machines you might want to use it on (lxplus etc.)
9. Assuming the certificate is located in `~/myCertificate.p12`, run the following commands
    - Export the certificate (you will be prompted for you import password which you set in step 2)
        ```bash
        openssl pkcs12 -clcerts -nokeys -in ~/myCertificate.p12 -out ~/.globus/usercert.pem
        ```
    - Export the private key (you will be prompted (1) for your import password which you set in step 2, and (2) to set a seperate PEM pass phrase)
        ```bash
        openssl pkcs12 -nocerts -in ~/myCertificate.p12 -out ~/.globus/userkey.pem
        chmod 0400 ~/.globus/userkey.pem
        ```
    
### Kerberos Access to LXPLUS
(based on https://frankenthal.dev/post/ssh_kerberos_keytabs_macos/)
1. Install the correct [SSH binary](https://github.com/rdp/homebrew-openssh-gssapi) which supports GSSAPI authentication (part of automated installation):
    ```bash
    $ brew tap rdp/homebrew-openssh-gssapi
    $ brew install rdp/homebrew-openssh-gssapi/openssh-patched --with-gssapi-support
    ```
    It is **NOT** necessary to follow the instructions on the terminal screen after the installation.
2. Place the `krb5.conf` [file](../kerberos/krb5.conf) in `/etc/` (part of automated installation).
3. Edit the `~/.ssh/config` file to include GSSAPI authentication for LXPLUS (part of automated installation).
4. Make a keytab file with your encrypted password. This step is to create a keytab file containing your password that will be fed to the kinit command in order to obtain a Kerberos ticket. On macOS X (which comes with the Heimdal flavor of Kerberos, and not MIT’s) the command to add a password for CERN’s account is:
    ```bash
    $ /usr/sbin/ktutil -k ~/.ssh/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3
    $ (type your password)
    ```
5. This step should have already been done as part of a previous LXPLUS keytab creation. If not, make your keytab file when logged in to one of the LXPLUS machines:
    ```bash
    $ ktutil 
    $ addent -password -p stipnis@CERN.CH -k 3 -e arcfour-hmac-md5
    $ (type your password)
    $ wkt keytab
    $ quit
    ```
6. Add the follwing command to `~/.bash_profile` (part of automated installation) :
    ```bash
    $ /usr/bin/kinit -kt ~/.ssh/keytab stipnis@CERN.CH
    ```
    This will grant you Kerberos tickets without having to type your password.


## Markdown Extensions

### VSCode
1. Markdown All In One: Improved editing, like auto numbered lists etc.
2. Markdown+Math: Dedicated math support as recommended by Markdown All In One docs
3. Markdown Preview Enhanced: Different preview (e.g. themes) to in-house one + export to pdf using pandoc + some extra functions (some redundant), uses own math rendering
4. Markdown Tables: Better support for formatting tables

### Sublime Text
1. Markdown Extended: Better Markdown syntax highlighting
2. MarkdownEditing: Improved editing, like auto numbered lists etc.
3. MarkdownPreview: Open HTML preview in a browser
4. MarkdownTOC: Add TOC to documents
5. LiveReload: Autoupdate browser preview generated by MarkdownPreview

## Disk Usage Apps
1. Coreutils du: used to define (LS colorized!) function fs() in ~/.functions
2. [gdu](https://github.com/dundee/gdu):
    1. Includes full fledged browser
    2. Binary name conflicts with coreutils du, so Homebrew will complain on a regular installation
    3. Hence, a sllightly different installation method: After coreutils has already been installed by Homebrew, run
        ```bash
        brew install -f gdu
        brew link --overwrite gdu
        ```
3. [duf](https://github.com/muesli/duf): High level overview of disk usage
    ```bash
    brew install duf
    ```
4. [diskus](https://github.com/sharkdp/diskus): Very simple but fast program that computes the total size of the current directory
    ```bash
    brew install diskus
    ```
5. [dirstat-rs](https://github.com/scullionw/dirstat-rs): Overview of the largest files
    ```bash
    brew tap scullionw/tap
    brew install dirstat-rs
    ```
6. [duc](https://github.com/zevv/duc): Collection of tools for inspecting and visualizing disk usage
    ```bash
    brew install duc
    ```
7. [dutree](https://github.com/nachoparker/dutree): LS colorized overview of file sizes
    ```bash
    brew install rust
    cargo install dutree
    ```
