#!/usr/bin/env sh

set -euf

# Get an absolute path from a relative one. Accounts for the existence of
# `realpath` on linux and otherwise falls back to a similar replacement
# function that works on Mac OS.
abspath() {
    if command -v realpath &> /dev/null; then
        realpath "$1"
    else
	# Derived from: https://stackoverflow.com/a/3572105
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    fi
}

mklink() {
    local abs_source="$(abspath $1)"
    local dest="${HOME}/$2"
    ln -fs "${abs_source}" "${dest}"
    echo "Linked '${abs_source}' to '${dest}'"
}

# Create required directories
mkdir -p "${HOME}/.gitconfig.d"

# Create links to config files
mklink ./git/.gitconfig .gitconfig
mklink ./git/salesforce.inc .gitconfig.d/salesforce.inc
mklink ./vim/.vimrc .vimrc
