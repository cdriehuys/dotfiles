#!/usr/bin/env sh

set -euf

full_status="$(acpi --battery)"
percent="$(echo "${full_status}" | grep -E --only-matching '[0-9]{1,3}%')"
remaining="$(echo "${full_status}" | grep -E --only-matching '[0-9:]+ remaining')"

time="$(echo "${remaining}" | cut -d' ' -f 1)"

# Return full and short text so we can optionally customize the background later
# which MUST be the third line of output.
echo " ${percent} (${time}) "
echo " ${percent} "

# Set urgent flag below 5% or use orange below 20%
[ ${percent%?} -le 5 ] && exit 33
[ ${percent%?} -le 20 ] && echo "#FF8000"
