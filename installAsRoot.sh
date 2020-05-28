#!/bin/bash

# Set the username.
username=$USER
if [[ $1 != '' ]]; then
  username=$1
else
  if [[ $username == 'root' ]]; then
    username='ian'
  fi
fi

# Set the email that will be passed to the base installation script.
email=$2
if [[ $email == '' ]]; then
  email='pub@ianwalter.dev'
fi

# Install 1Password CLI.
if [[ ! `which op` ]]; then

  printf "\n💁 Installing 1Password CLI \n\n"

  opVersion='v1.0.0'
  apt update && apt install -y unzip git
  curl -O https://cache.agilebits.com/dist/1P/op/pkg/$opVersion/op_linux_amd64_$opVersion.zip
  unzip op_linux_amd64_$opVersion.zip
  mv op /usr/local/bin

  printf "\n👉 Login to 1Password by running 'op signin <domain> <email>'\n\n"

fi

# Create a new user if the given username is different from the current user.
if [[ $USER != $username ]]; then
  # Generate a random password.
  password=$(openssl rand -base64 9)
  passwordMd5=$(openssl passwd -1 "${password}")

  # Create the user.
  useradd $username --password "${passwordMd5}" --create-home

  # Add user to sudoers group.
  usermod -aG sudo $username

  # Print the result.
  if [[ $? == 0 ]]; then
    printf "\n✅ Created user \"${username}\" with password \"${password}\"\n\n"
  else
    printf "\n🚫 Failed to create user \"${username}\"\n"
  fi
fi

# Execute the base installation script as the new user and then switch to the
# user.
sudo -H -u $username bash -c "curl https://raw.githubusercontent.com/ianwalter/dotinit/master/install.sh | bash -s ${email}"
su - $username
