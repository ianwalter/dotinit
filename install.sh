#!/bin/bash

# Set the environment the script will target.
environment=$DISPLAY
if [[ $environment != '' ]]; then
  environment='desktop'
fi

# Set the email the script will use to generate a SSH key.
email=$1
if [[ $email == '' ]]; then
  email='pub@ianwalter.dev'
fi

# Install Homebrew (and Linuxbrew).
printf "\n🍺 Installing Homebrew \n\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install 1Password CLI.
printf "\n💁 Installing 1Password CLI \n\n"
if [[ $(uname) == 'Linux' ]]; then
  opVersion='v1.0.0'
  sudo apt-get update && sudo apt-get install -y unzip git
  curl -O https://cache.agilebits.com/dist/1P/op/pkg/$opVersion/op_linux_amd64_$opVersion.zip
  unzip op_linux_amd64_$opVersion.zip
  sudo mv op /usr/local/bin
else
  brew cask install 1password-cli
fi

printf "\n👉 Login to 1Password by running \"op signin <domain> <email>\"\n\n"

# Generate an SSH key.
if [[ ! -d ~/.ssh/id_rsa ]]; then
  printf "\n🔑 Generating an SSH key for ${email}\n\n"
  ssh-keygen -t rsa -b 4096 -q -N "" -f ~/.ssh/id_rsa -C $email
fi

if [[ $(uname) == 'Linux' ]]; then

  if [[ $environment == 'desktop' ]]; then

    # Install xclip so that the script can easily copy the SSH public key
    # generated in the next step to the clipboard.
    if [[ $environment == 'desktop' ]]; then
      sudo apt-get install -y xclip
    fi

    # Copy the generated SSH public key to the clipboard.
    xclip -sel clip < ~/.ssh/id_rsa.pub

    # Open the browser to the GitHub settings page where you can add a new SSH
    # key.
    xdg-open https://github.com/settings/ssh/new

  else

    # If targetting a non-desktop environment, log the GitHub URL to add the
    # generated SSH key since the script can't automatically open it in a
    # browser.
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

  printf '\n✅ Success! Paste your SSH key into GitHub \n\n';

fi
