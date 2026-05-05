# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# USER #########################################################################
alias ls='ls -F --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# rx for groups/others
umask 022

# History
shopt -s histappend

# Editor
export EDITOR='vim'
export VISUAL='vim'

# vim behavior in terminal
set -o vi

# Expand env vars when autocompleting
shopt -s direxpand

export PRJ="/home/${USER}/workspace/projects"

# Toolchains
ARCH=$(uname -m)

case "$ARCH" in
    aarch64)
        export PATH="${HOME}/.local/opt/arm-gnu-toolchain-15.2.rel1-aarch64-arm-none-eabi/bin:${HOME}/.local/opt/xpack-openocd-0.12.0-7/bin:${PATH}"
        ;;
    x86_64)
        export PATH="${HOME}/.local/opt/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi/bin:${HOME}/.local/opt/xpack-openocd-0.12.0-7/bin:${PATH}"
        ;;
esac

# XDG directory variable - typically ~/.config
[[ ! -z XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="${HOME}/.config"

# Load pyenv if present
if [[ -d "${HOME}/.pyenv" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    [[ -d "${PYENV_ROOT}/bin" ]] && export PATH="${PYENV_ROOT}/bin:$PATH"
    eval "$(pyenv init -)"
fi

# DO LAST #########################################################################
# Source local machine .bashrc if present ##########################################
if [[ -f "${HOME}/.bashrc.local" ]]; then
    . "${HOME}/.bashrc.local"
fi
