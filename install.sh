#!/bin/bash

set -euf
set -o pipefail

# Configuration options that are specific to me.
ssh_key_comment='chathan@driehuys.com'

COLUMNS=80
if [ -n "${TERM}" ]; then
    COLUMNS="$(tput cols)"
fi

dotfiles="${HOME}/.dotfiles"

section_header() {
    echo
    for ((i=0; i<COLUMNS; i++)); do
        echo -n "="
    done
    echo -e "\n$@"
    for ((i=0; i<COLUMNS; i++)); do
        echo -n "-"
    done
    echo -e '\n\n'

}

install() {
    echo "Installing packages: $@"
    sudo pacman --sync --refresh --noconfirm --quiet --needed "$@" >/dev/null
}

configure_audio() {
    section_header "Audio"

    install pulseaudio
}

configure_backlight() {
    section_header "Backlight"

    install acpilight

    local needs_video_membership=
    if [[ -d "/sys/class/backlight/intel_backlight" ]]; then
        echo "Configuring udev rules for intel backlight."
        sudo ln -fs "${dotfiles}/backlight/udev.rules" /etc/udev/rules.d/90-backlight.rules
        echo "Wrote udev rule to allow backlight management by 'video' group: /etc/udev/rules.d/90-backlight.rules"
        needs_video_membership=true
    fi

    if "${needs_video_membership}"; then
        # The user needs to be a part of the video group in order to manage the
        # backlight without using 'sudo'.
        if id -nG "${USER}" | grep -qw "video"; then
            echo "User is already a member of the 'video' group."
        else
            sudo usermod -aG video "${USER}"
            echo "Added user to 'video' group"
        fi
    fi
}

configure_i3() {
    section_header "i3 Window Manager"

    # Install i3 along with a few necessary dependencies. For example, urxvt is
    # installed to make sure there is a terminal that i3 can open.
    install dmenu i3-gaps i3blocks i3lock i3status rxvt-unicode

    echo "Writing config files:"
    local config_dir="${HOME}/.i3"

    if [[ -d "${config_dir}" ]]; then
        echo "  - Config directory already exists: ${config_dir}"
    else
        mkdir -p "${HOME}/.i3"
        echo "  - Created config directory: ${config_dir}"
    fi

    ln -fs "${dotfiles}/i3/config" "${config_dir}/config"
    ln -fs "${dotfiles}/i3/i3status.conf" "${config_dir}/i3status.conf"
    echo "  - Created i3 config file: ${config_dir}/config"
    echo "  - Created i3status config file: ${config_dir}/i3status.conf"
}

configure_ssh() {
    section_header "SSH"

    install openssh

    local ssh_key_types=(
        ed25519
    )
    for key_type in "${ssh_key_types[@]}"; do
        local private_key="${HOME}/.ssh/id_${key_type}"
        local public_key="${private_key}.pub"

        if [[ -f "${private_key}" ]]; then
            echo "Key already exists: ${private_key}"
        else
            ssh-keygen -t "${key_type}" -f "${private_key}" -C "${ssh_key_comment}" -N ""
            echo "Generated SSH key: ${private_key}"
        fi
    done
}

configure_vim() {
    section_header "ViM"

    install vim

    ln -fs "${dotfiles}/vim/vimrc" "${HOME}/.vimrc"
    echo "Created ViM configuration file: ${HOME}/.vimrc"
}

configure_audio
configure_backlight
configure_i3
configure_ssh
configure_vim
