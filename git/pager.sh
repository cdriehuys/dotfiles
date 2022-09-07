#!/usr/bin/env sh

set -euf

if command -v delta >/dev/null 2>&1; then
    pager="delta"
else
    pager="${PAGER:-less}"
fi

$pager "$@"

