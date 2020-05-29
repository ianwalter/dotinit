# dotinit
> Init script for installing Ian's [dotfiles][dotfilesUrl] system configuration

## Installation

Add your email address as a paremeter or mine will be used to generate a SSH
key!

```console
bash <(curl https://raw.githubusercontent.com/ianwalter/dotinit/master/install.sh) <email>
```

If you're `root` and need to create a new user, run this instead and pass a name
for the user:

```console
bash <(curl https://raw.githubusercontent.com/ianwalter/dotinit/master/installAsRoot.sh) <username> <email>
```

## What it does

1. (If root) Creates a new user with the specified name.
2. (If root) Switches to the new user and executes the base install script.
3. Installs [Homebrew][brewUrl] so that the 1Password CLI can be installed.
4. Installs [1Password CLI][opUrl] so that secrets can be retrieved.
5. (If Linux desktop) Installs [xclip][xclipUrl]
6. Generates a new SSH key with the specified email address.
7. Outputs information on how to log in to 1Password CLI.
8. Outputs information on how to add your SSH key to GitHub.

## License

Hippocratic License - See [LICENSE][licenseUrl]

&nbsp;

Created by [Ian Walter](https://ianwalter.dev)

[dotfilesUrl]: https://github.com/ianwalter/dotfiles
[brewUrl]: https://brew.sh
[opUrl]: https://1password.com/downloads/command-line/
[xclipUrl]: https://github.com/astrand/xclip
[licenseUrl]: https://github.com/ianwalter/dotinit/blob/master/LICENSE
