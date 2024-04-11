# Dotfiles

My dotfiles.

## Prerequisites

You need `git` to clone the repository and `stow` to link files to the
appropriate places.

## Installation

Clone the repository to `$HOME/.dotfiles`. The directory name may be something
other than `.dotfiles`, but it must be in the `$HOME` directory so that `stow`
creates links in the right place.

Use `stow` on each desired bundle.

## Config Dependencies

Certain configurations expect certain dependencies. In addition, there are some
common tools that I like to have.

**Arch Linux:**

```shell
pacman -S bat bolt fd fwupd htop less ripgrep udisks2
```

### Git

**Arch Linux:**

```shell
pacman -S git git-delta vim
```

### Sway

**Arch Linux:**

```shell
pacman -S acpi alacritty brightnessctl gnome-keyring greetd greetd-tuigreet \
    i3blocks kanshi pamixer sway swaybg swayidle swaylock \
    ttf-jetbrains-mono-nerd wl-clipboard wofi
```
