#!/usr/bin/env bash

# Make sudo passwordless
if ! sudo grep -q "%wheel		ALL=(ALL) NOPASSWD: ALL" "/etc/sudoers"; then

  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  sudo cp /etc/sudoers /etc/sudoers.back
  echo '%wheel		ALL=(ALL) NOPASSWD: ALL #atomantic/dotfiles' | sudo tee -a /etc/sudoers > /dev/null
  sudo dscl . append /Groups/wheel GroupMembership $(whoami)
  bot "You can now run sudo commands without password!"
  
fi


        