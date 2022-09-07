#!/usr/bin/env sh

set -euf

if command -v delta &> /dev/null; then
    pager="delta"
else
    pager="${PAGER}"
fi

$pager "$@"

