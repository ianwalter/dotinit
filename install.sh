#!/bin/bash

# Set the environment the script will target.
environment=$1
if [[ $environment == '' ]]; then
  environment='desktop'
fi

# Set the email the script will use to generate a SSH key.
email=$2
if [[ $email == '' ]]; then
  email='public@iankwalter.com'
fi

# Log what the script will do.
printf "\n💁 Initializing ${environment} setup for ${email}...\n\n"

if [[ $(uname) == 'Linux' ]]; then

  # Update Aptitude repository cache.
  sudo apt-get update

  # Install xclip so that the script can easily copy the SSH public key
  # generated in the next step to the clipboard.
  sudo apt-get install -y xclip

fi

# Generate the SSH key.
ssh-keygen -t rsa -b 4096 -q -N "" -f ~/.ssh/id_rsa -C $email

if [[ $(uname) == 'Linux' && $environment == 'desktop' ]]; then

  # Copy the generated SSH public key to the clipboard.
  xclip -sel clip < ~/.ssh/id_rsa.pub

  # Open the browser to the GitHub settings page where you can add a new SSH
  # key.
  xdg-open https://github.com/settings/ssh/new

fi

printf '\n✅ Success!\n\n';

if [[ $(uname) == 'Darwin' ]]; then

  # Copy the generated SSH public key to the clipboard.
  pbcopy < ~/.ssh/id_rsa.pub

  # Open the browser to the GitHub settings page where you can add a new SSH
  # key.
  if [[ $environment == 'desktop' ]]; then
    open https://github.com/settings/ssh/new
  fi

fi

# If targetting a server environment, log the GitHub URL to add the generated
# SSH key since the script can't automatically open it in a browser.
if [[ $environment == 'server' ]]; then
  ip=$(curl ifconfig.me)
  printf "\n📋 Run 'ssh root@${ip} \"cat ~/.ssh/id_rsa.pub\" | pbcopy' to copy your SSH public key to your clipboard."
  printf '\n🔒 Add your SSH public key to GitHub: https://github.com/settings/ssh/new\n\n'
fi
