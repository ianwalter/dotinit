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

# Set the username.
username=$USER
if [[ $2 != '' ]]; then
  username=$2
else
  if [[ $username == 'root' ]]; then
    username='ian'
  fi
fi

# Log what the script will do.
printf "\n💁 Initializing ${environment} setup for ${email} ${username}...\n\n"

# Create a new user if the given username is different from the current user.
is_new_user=''
if [[ $USER != $username ]]; then
  is_new_user='true'

  # Generate a random password.
  password=$(openssl rand -base64 9)
  password_md5=$(openssl passwd -1 "${password}")

  # Create the user.
  useradd $username --password "${password_md5}" --create-home

  # Add user to sudoers group.
  usermod -aG sudo $username

  # Print the result.
  if [[ $? == 0 ]]; then
    printf "\n✅ Created user \"${username}\" with password \"${password}\"\n\n"
  else
    printf "\n🚫 Failed to create user \"${username}\"\n"
  fi
fi

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

# If a new user was created, switch to the new user.
if [[ $is_new_user != '' ]]; then
  su - $username
fi
