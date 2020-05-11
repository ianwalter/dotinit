#!/bin/bash

# Set the environment the script will target.
environment=$DISPLAY
if [[ $environment != '' ]]; then
  environment='desktop'
fi

# Set the email the script will use to generate a SSH key.
email=$1
if [[ $email == '' ]]; then
  email='public@iankwalter.com'
fi

# Log what the script will do.
printf "\n💁 Initializing ${environment} setup for ${email}...\n\n"

if [[ $(uname) == 'Linux' ]]; then

  # Update Aptitude repository cache and install git.
  sudo apt-get update && sudo apt-get install -y git


  # Install xclip so that the script can easily copy the SSH public key
  # generated in the next step to the clipboard.
  if [[ $environment == 'desktop' ]]; then
    sudo apt-get install -y xclip
  fi

fi

# Generate the SSH key.
ssh-keygen -t rsa -b 4096 -q -N "" -f ~/.ssh/id_rsa -C $email

printf '\n✅ Success!\n\n';

if [[ $(uname) == 'Linux' ]]; then

  if [[ $environment == 'desktop' ]]; then

    # Copy the generated SSH public key to the clipboard.
    xclip -sel clip < ~/.ssh/id_rsa.pub

    # Open the browser to the GitHub settings page where you can add a new SSH
    # key.
    xdg-open https://github.com/settings/ssh/new
    
  else
  
    # If targetting a non-desktop environment, log the GitHub URL to add the
    # generated SSH key since the script can't automatically open it in a browser.
    ip=$(curl ifconfig.me)
    printf "\n📋 Run 'ssh root@${ip} \"cat ~/.ssh/id_rsa.pub\" | pbcopy' to copy your SSH public key to your clipboard."
    printf '\n🔒 Add your SSH public key to GitHub: https://github.com/settings/ssh/new\n\n'
    
  fi
  
else

  # Copy the generated SSH public key to the clipboard.
  pbcopy < ~/.ssh/id_rsa.pub

  # Open the browser to the GitHub settings page where you can add a new SSH
  # key.
  open https://github.com/settings/ssh/new

fi

