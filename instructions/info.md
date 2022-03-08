# Useful information for setting up a macOS system
(information is valid as of macOS Monterey)

## Table of contents:
  - [Shell](#shell)
  - [Sudo](#sudo)
  - [XQuartz](#xquartz)
  - [Duti](#duti)
  - [LaTeX](#latex)
  - [VSCode](#vscode)
  - [CERN](#cern)
      - [Renew Grid Certificate](#renew-grid-certificate)
      - [Kerberos Access to LXPLUS](#kerberos-access-to-lxplus)
  - [Sublime Text](#sublime-text)
  - [Disk Usage Apps](#disk-usage-apps)
    - [Command Line Tools Path](#command-line-tools-path)

## Shell
- Get current shell:
    ```bash
    dscl . -read ~/ UserShell
    ```
- Add (e.g. /usr/local/bin/bash) to list of approved shells:
    ```bash
    _SHELL="/usr/local/bin/bash"
    echo $_SHELL | sudo tee -a /private/etc/shells
    ```
- Change default shell for the current user (to e.g. /usr/local/bin/bash):
    ```bash
    _SHELL="/usr/local/bin/bash"
    sudo chsh -s $_SHELL $(id -un)
    ```

## Sudo
- Make sudo passwordless for the current user:
   Add file (e.g. `sudoers`) to `/etc/sudoers.d` containing "<username> ALL=(ALL) NOPASSWD:ALL":
    ```bash
    echo "$(id -un) ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/sudoers
    ```

## XQuartz
- Add colour by adding an `.Xdefaults` file with the following contents into the `HOME` directory:
    ```
    xterm*Background:               black
    xterm*cursorColor:              white
    xterm*Foreground:               white
    ```

## Duti
- Get default application information for e.g. jpg files:
    ```bash
    _EXT=jpg
    duti -x $_EXT
    ```

## LaTeX
- Compile command:
	```bash
	cd build
	latexmk --output-directory=. -pdflua -shell-escape ../source/hello.tex
	```
- Jump from the pdf to source code:
   ```
   Shift + Cmd + Click	
   ```
- Jump from the source code to the pdf:
    ```
    VSCode: Cmd + Option + j    
    Sublime Text: Cmd + l; j
    ```

## VSCode
- Save list of installed extensions
    ```bash
    code --list-extensions > Codefile
    ```
- Markdown extensions:
  1. Markdown All In One: Improved editing, like auto numbered lists etc.
  2. Markdown+Math: Dedicated math support as recommended by Markdown All In One docs
  3. Markdown Preview Enhanced: Different preview (e.g. themes) to in-house one + export to pdf using pandoc + some extra functions (some redundant), uses own math rendering
  4. Markdown Table: Better support for formatting tables

## CERN
#### Renew Grid Certificate
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
#### Kerberos Access to LXPLUS
(based on https://frankenthal.dev/post/ssh_kerberos_keytabs_macos/)
1. Install the correct [SSH binary](https://github.com/rdp/homebrew-openssh-gssapi) which supports GSSAPI authentication (part of automated installation):
    ```bash
    brew tap rdp/homebrew-openssh-gssapi
    brew install rdp/homebrew-openssh-gssapi/openssh-patched --with-gssapi-support
    ```
    It is **NOT** necessary to follow the instructions on the terminal screen after the installation.
2. Place the [`krb5.conf`](../kerberos/krb5.conf) file in `/etc/` (part of automated installation).
3. Edit the [`~/.ssh/config`](../ssh/config) file to include GSSAPI authentication for LXPLUS (part of automated installation).
4. Make a keytab file with your encrypted password. This step is to create a keytab file containing your password that will be fed to the kinit command in order to obtain a Kerberos ticket. On macOS X (which comes with the Heimdal flavor of Kerberos, and not MIT’s) the command to add a password for CERN’s account is:
    ```bash
    /usr/sbin/ktutil -k ~/.ssh/keytab add -p stipnis@CERN.CH -e arcfour-hmac-md5 -V 3
    
    (type your password)
    ```
5. This step should have already been done as part of a previous LXPLUS keytab creation. If not, make your keytab file when logged in to one of the LXPLUS machines:
    ```bash
    ktutil 
    addent -password -p stipnis@CERN.CH -k 3 -e arcfour-hmac-md5
    
    (type your password)
    
    wkt keytab
    quit
    ```
6. The follwing command can now be used to grant Kerberos tickets without having to type a password:
    ```bash
    /usr/bin/kinit -kt ~/.ssh/keytab stipnis@CERN.CH
    ```

## Sublime Text
- Mardown extensions:
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

### Command Line Tools Path
- Set to standalone command line tools:
  ```bash
  xcode-select --switch "/Library/Developer/CommandLineTools"
  ```

- Set to XCode:
  - Via CLI:
     ```bash
     xcode-select --switch "/Applications/Xcode.app/Contents/Developer"
     ```
  - Via XCode app:
       - Open the XCode app
       - XCode (menubar) -> Preferences -> Locations -> Locations -> Command Line Tools -> Select "XCode xx.x.x"