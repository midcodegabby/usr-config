#!/bin/bash

# Create symlinks between $HOME/.* and the versions in this repo

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Nice colors for linking messages
GREEN='\033[0;32m'
BYELLOW='\033[1;33m'
NO_COLOR='\033[0m'

VERBOSE=false
FORCE=false

# Check if XDG_CONFIG_HOME is set
if [[ ! -z $XDG_CONFIG_HOME ]]; then
    XDG_CONFIG_HOME="${HOME}/.config"
fi

################################################################################
## create_symlink
################################################################################
create_symlink() {
    local file_path="$1"
    local link_path="$2"

    ln -sf "${file_path}" "${link_path}"
    printf "${GREEN}%s${NO_COLOR} -> %s\n" "${link_path}" "${file_path}"
    return 0
}
################################################################################

################################################################################
## check_and_create_symlink
################################################################################
check_and_create_symlink() {
    local file_path="$1"
    local link_path="$2"

    # Check if link_path exists
    if [[ -d "${link_path%/*}" ]]; then
        # Check if link already exists
        if [[ -f "${link_path}" ]]; then
            # Check if link already links to this repo's file
            if [[ "$(readlink -f ${link_path})" == "${file_path}" ]]; then
                [[ $VERBOSE == true ]] && echo "${link_path} already links to ${file_path}"
                return 1
            fi

            if [[ $FORCE == true ]]; then
                create_symlink "${file_path}" "${link_path}"
                return 0
            else
                printf "${BYELLOW}WARNING: local version or expired symlink of %s already exists, skipping link...\n" "${link_path}"
                return 1
            fi
        else
            create_symlink "${file_path}" "${link_path}"
        fi
    else
        # Create folder
        mkdir -p "${link_path%/*}"
        create_symlink "${file_path}" "${link_path}"
    fi
}
################################################################################

while getopts "vh" opt; do
    case $opt in
        v)
            VERBOSE=true
            ;;
        f)
            FORCE=true
            ;;
        ?|h)
            echo "Usage: "${BASH_SOURCE[0]}" [-v] [-f]"
            echo "  -v: verbose output"
            echo "  -f: force"
            exit 1
            ;;
    esac
done

dotfiles=( $(find "${SCRIPT_DIR}" -path "${SCRIPT_DIR}/.git" -prune -o \
             ! -name "README.md" \
             ! -name "${BASH_SOURCE[0]##*/}" \
             ! -name "README.md" \
             ! -name "LICENSE" \
             -type f -print) )

# Loop over all dotfiles in this repo
for dotfile in "${dotfiles[@]}"; do
    relative_link_path="${HOME}/$(echo ${dotfile} | sed 's|'"${SCRIPT_DIR}/"'||g')"
    check_and_create_symlink ${dotfile} ${relative_link_path}
done
