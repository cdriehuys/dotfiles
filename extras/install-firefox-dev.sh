#!/usr/bin/env sh

# Ubuntu installer for Firefox Developer Edition. This script is adapted from
# the StackExchange answer:
# https://askubuntu.com/a/548005

set -euf

if [ "$(id -u)" = "0" ]; then
    >&2 echo "ERROR: Do not run this script as root. Calls to 'sudo' will be performed as needed."
    exit 1
fi

firefox_archive=$1
echo "Installing Firefox from archive: ${firefox_archive}"
echo

unpack_dir="$(mktemp --directory)"
echo "Created directory to unpack archive in: ${unpack_dir}"
echo

echo "Unpacking archive..."
cd "${unpack_dir}"
# Firefox archive is packed in a bz2 format. Unpacking it creates a `firefox`
# directory.
tar -jxvf "${firefox_archive}"
echo "Unpacked Firefox archive."
echo

firefox_directory=/opt/firefox-dev
echo "Moving Firefox contents to: ${firefox_directory}"
sudo mv "${unpack_dir}/firefox" "${firefox_directory}"
echo "Moved Firefox."
echo

launcher="${HOME}/.local/share/applications/firefox-dev.desktop"
echo "Creating launcher: ${launcher}"
tee "${launcher}" <<EOF
[Desktop Entry]
Name=Firefox Developer
GenericName=Firefox Developer Edition
Exec=${firefox_directory}/firefox %u
Terminal=false
Icon=${firefox_directory}/browser/chrome/icons/default/default128.png
Type=Application
Categories=Application;Network;X-Developer;
Comment=Firefox Developer Edition Web Browser.
StartupWMClass=Firefox Developer Edition
EOF
echo

rm -rf "${unpack_dir}"
echo "Removed temporary directory: ${unpack_dir}"
echo

echo "SUCCESS"
echo "Installed Firefox Developer Edition."
