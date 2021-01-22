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

configure_bash() {
    section_header "Bash"

    install bash-completion

    local bash_config="${HOME}/.bashrc"
    local bash_config_dir="${HOME}/.bashrc.d"

    if [[ -d "${bash_config_dir}" ]]; then
        echo "Bash config directory exists: ${bash_config_dir}"
    else
        mkdir "${bash_config_dir}"
        echo "Created Bash config directory: ${bash_config_dir}"
    fi

    ln -fs "${dotfiles}/bash/bashrc" "${bash_config}"
    echo "Wrote bash config: ${bash_config}"

    ln -fs "${dotfiles}/bash/bash-completion.sh" "${bash_config_dir}/bash-completion.sh"
    echo "Wrote bash config script: ${bash_config_dir}/bash-completion.sh"

    ln -fs "${dotfiles}/bash/local_bin.sh" "${bash_config_dir}/local_bin.sh"
    echo "Wrote bash config script: ${bash_config_dir}/local_bin.sh"
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

configure_scripts() {
    section_header "User Scripts"

    local scripts="${HOME}/.local/bin"
    if [[ -d "${scripts}" ]]; then
        echo "Scripts directory exists: ${scripts}"
    else
        mkdir -p "${scripts}"
        echo "Created scripts directory: ${scripts}"
    fi

    find "${dotfiles}/scripts" -type f -print0 |
        while IFS= read -r -d '' script; do
            local script_name="$(basename "${script}")"
            ln -fs "${script}" "${scripts}/${script_name}"
            echo "  - Created local script: ${scripts}/${script_name}"
        done
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

configure_x11() {
    section_header "X11"

    local x11_config_dir="${HOME}/.Xresources.d"
    if [[ -d "${x11_config_dir}" ]]; then
        echo "X11 config directory exists: ${x11_config_dir}"
    else
        mkdir "${x11_config_dir}"
        echo "Created X11 config directory: ${x11_config_dir}"
    fi

    ln -fs "${dotfiles}/X11/vars" "${x11_config_dir}/vars"
    echo "Created X11 variables config: ${x11_config_dir}/vars"

    if [[ ! -f "${x11_config_dir}/vars_override" ]]; then
        # Initialize the variables override to a copy of the default variables
        # with all values commented out.
        cat > "${x11_config_dir}/vars_override" <<EOF
! Override variables from the default configuration here. The variables
! available when this file are listed as comments. To override a value,
! uncomment the line and provide a value.
!
! This file will not be regenerated as long as it exists. The authoritative
! list of variables exists in ~/.Xresources.d/vars.

EOF
        cat "${dotfiles}/X11/vars" >> "${x11_config_dir}/vars_override"
        sed -i'' 's/^\([^!]\)/! \1/g' "${x11_config_dir}/vars_override"
        echo "Created X11 variables override config: ${x11_config_dir}/vars_override"
    else
        echo "X11 variable override already exists: ${x11_config_dir}/vars_override"
    fi

    ln -fs "${dotfiles}/X11/Xresources" "${HOME}/.Xresources"
    echo "Created Xresources file: ${HOME}/.Xresources"
}

configure_audio
configure_backlight
configure_bash
configure_i3
configure_scripts
configure_ssh
configure_vim
configure_x11
