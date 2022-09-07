#!/usr/bin/env bash

# Use homebrew to install frequently used utility packages.

set -eufo pipefail

brew_packages=(
    bat
    fd
    git-delta
    ripgrep
    tree
)

brew install "${brew_packages[@]}"

