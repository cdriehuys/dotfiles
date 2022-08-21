# Dotfiles

My dotfiles.

## Prerequisites

Install `git`. Otherwise you can't clone the repository.

## Installation

Use `install.sh` to make all the appropriate symlinks.

## Useful Information

### Changing Shells

To change your shell, use:

```bash
chsh
```

Log out and back in for the change to take effect.

### Git on Ubuntu

The Git version from the default repositories on Ubuntu 18 is outdated. Add the
Git PPA and upgrade Git:

```bash
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt upgrade git
```
