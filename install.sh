#!/bin/bash

if [[ $(uname) == 'Linux' ]]; then

  # Update Aptitude repository cache.
  sudo apt update

  # Install xclip so that the script can easily copy the SSH public key
  # generated in the next step to the clipboard.
  sudo apt install xclip

fi

# Generate the SSH key.
ssh-keygen -t rsa -b 4096 -q -N "" -f ~/.ssh/id_rsa \
  -C "public@iankwalter.com" # Change me!


if [[ $(uname) == 'Linux' ]]; then

  # Copy the generated SSH public key to the clipboard.
  xclip -sel clip < ~/.ssh/id_rsa.pub

  # Open the browser to the GitHub settings page where you can add a new SSH
  # key.
  xdg-open https://github.com/settings/ssh/new

fi


if [[ $(uname) == 'Darwin' ]]; then

  # Copy the generated SSH public key to the clipboard.
  pbcopy < ~/.ssh/id_rsa.pub

  # Open the browser to the GitHub settings page where you can add a new SSH
  # key.
  open https://github.com/settings/ssh/new

fi
