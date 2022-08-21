#!/usr/bin/env sh

set -euf

# Get an absolute path from a relative one. Abstracted into a function in case
# we need a separate implementation for different OSs later.
abspath() {
    realpath "$1"
}

mklink() {
    local abs_source="$(abspath $1)"
    local dest="${HOME}/$2"
    ln -fs "${abs_source}" "${dest}"
    echo "Linked '${abs_source}' to '${dest}'"
}

mklink ./git/.gitconfig .gitconfig
mklink ./vim/.vimrc .vimrc
