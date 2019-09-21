#!/bin/bash

environment=$1
if [[ $environment == '' ]]; then
  environment='desktop'
fi

email=$2
if [[ $email == '' ]]; then
  email='public@iankwalter.com'
fi

echo "Initializing ${environment} setup for ${email}..."

if [[ $(uname) == 'Linux' ]]; then

  # Update Aptitude repository cache.
  sudo apt update

  # Install xclip so that the script can easily copy the SSH public key
  # generated in the next step to the clipboard.
  sudo apt install xclip

fi

# Generate the SSH key.
ssh-keygen -t rsa -b 4096 -q -N "" -f ~/.ssh/id_rsa -C $email

if [[ $(uname) == 'Linux' ]]; then

  # Copy the generated SSH public key to the clipboard.
  xclip -sel clip < ~/.ssh/id_rsa.pub

  # Open the browser to the GitHub settings page where you can add a new SSH
  # key.
  if [[ $environment == 'desktop' ]]; then
    xdg-open https://github.com/settings/ssh/new
  fi

fi

if [[ $(uname) == 'Darwin' ]]; then

  # Copy the generated SSH public key to the clipboard.
  pbcopy < ~/.ssh/id_rsa.pub

  # Open the browser to the GitHub settings page where you can add a new SSH
  # key.
  if [[ $environment == 'desktop' ]]; then
    open https://github.com/settings/ssh/new
  fi

fi

if [[ $environment == 'server' ]]; then
  echo 'Add your SSH public key to GitHub: https://github.com/settings/ssh/new'
fi
