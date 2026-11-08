#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RICE_DIR="$SCRIPT_DIR/RiceFiles"

if [[ $EUID -eq 0 ]]; then
    echo 'Please run this script as your normal user; it will use sudo for system files.' >&2
    exit 1
fi
if [[ ! -d "$RICE_DIR" ]]; then
    printf 'RiceFiles was not found next to this script: %s\n' "$RICE_DIR" >&2
    exit 1
fi

log_file="$HOME/NikoRice/AutoRice_Install.log"
mkdir -p "$(dirname -- "$log_file")"
log_failure() { printf '%s\n' "$*" | tee -a "$log_file" >&2; }

if [[ -f "$RICE_DIR/i3status.conf" ]]; then
    sudo install -D -m 0644 "$RICE_DIR/i3status.conf" /etc/i3status.conf || log_failure 'Could not install /etc/i3status.conf.'
fi
if [[ -f "$RICE_DIR/i3lock" ]]; then
    sudo install -D -m 0755 "$RICE_DIR/i3lock" /usr/local/bin/i3lock || log_failure 'Could not install the custom i3lock binary.'
fi

# Expand the home path for LightDM; its greeter does not inherit the user's
# HOME environment variable from an interactive shell.
if [[ -f "$RICE_DIR/lightdm-gtk-greeter.conf" ]]; then
    if [[ -d /etc/lightdm ]]; then
        temp_config="$(mktemp)"
        sed "s|\${HOME}|$HOME|g" "$RICE_DIR/lightdm-gtk-greeter.conf" > "$temp_config"
        sudo install -D -m 0644 "$temp_config" /etc/lightdm/lightdm-gtk-greeter.conf || log_failure 'Could not install the LightDM greeter configuration.'
        rm -f -- "$temp_config"
    else
        log_failure 'LightDM is not installed; skipping its greeter configuration.'
    fi
fi

printf '\nSet Zsh as your default shell? (y/n) '
read -r answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    zsh_path="$(command -v zsh || true)"
    if [[ -n "$zsh_path" ]]; then
        chsh -s "$zsh_path" || log_failure 'Could not change the default shell. You can run chsh -s "$(command -v zsh)" later.'
    else
        log_failure 'Zsh is not installed; skipping the shell change.'
    fi
fi

printf '\nPart 3 is complete. Reboot to apply the remaining system changes.\n'
read -r -p 'Reboot now? (y/n) ' answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo systemctl reboot
fi
