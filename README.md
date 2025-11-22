# Dotfiles

My dotfiles.

## Prerequisites

You need `git` to clone the repository and `stow` to link files to the
appropriate places.

### ZSH

In order to apply the ZSH config, ZSH and [Oh My ZSH](https://ohmyz.sh/) must be
installed. It's much easier to do this before running `stow zsh`.

## Installation

Clone the repository to `$HOME/.dotfiles`. The directory name may be something
other than `.dotfiles`, but it must be in the `$HOME` directory so that `stow`
creates links in the right place.

Use `stow` on each desired bundle.

## Post-Installation Configuration

Some bundles require manual steps after installation.

### SSH

Enable the SSH agent with:

```shell
systemctl --user enable --now ssh-agent
```

## Config Dependencies

Certain configurations expect certain dependencies. In addition, there are some
common tools that I like to have.

**Arch Linux:**

```shell
pacman -S bat bolt fd fwupd htop less ripgrep udisks2 vim
```

**Fedora:**

```shell
dnf install bat fd-find ripgrep vim-enhanced
```

### Git

**Arch Linux:**

```shell
pacman -S git git-delta
```

**Fedora:**

```shell
dnf install git git-delta
```

### Sway

**Arch Linux:**

```shell
pacman -S acpi alacritty brightnessctl gnome-keyring greetd greetd-tuigreet \
    i3blocks kanshi pamixer sway swaybg swayidle swaylock \
    ttf-jetbrains-mono-nerd waybar wl-clipboard wofi
```
