#!/bin/bash

# Create symlinks between $HOME/.* and the versions in this repo

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Nice colors for linking messages
GREEN='\033[0;32m'
RED='\033[0;31m'
BYELLOW='\033[1;33m'
NO_COLOR='\033[0m'

# Enable globbing of dotfiles in wildcard
shopt -s dotglob

# Loop over all dotfiles in this repo
for dotfile_path in "${SCRIPT_DIR}"/*; do
    # Searches l-r across dotfile_path, deletes everything before the last /
    dotfile="${dotfile_path##*/}"

    # Skip to next loop if dotfile is any of these 
    # .git dir, LICENSE, or this script
    [[ "$dotfile" == ".git" ]] && continue
    [[ "$dotfile" == "${BASH_SOURCE[0]##*/}" ]] && continue
    [[ "$dotfile" == "LICENSE" ]] && continue

    if [[ -f "${HOME}/${dotfile}" ]]; then
        printf "${BYELLOW}WARNING: local version of %s already exists, skipping link...\n" "$dotfile"
	    continue
    else
        ln -s "${dotfile_path}" "${HOME}/${dotfile}"
        printf "${GREEN}~/%s${NO_COLOR} -> %s\n" "$dotfile" "$dotfile_path"
    fi
done

# Disable globbing of dotfiles in wildcard
shopt -u dotglob
