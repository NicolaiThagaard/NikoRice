#!/usr/bin/env bash
# One-command installer for the NikoRice i3/X11 setup.
# Run from the cloned repository as your normal user: bash ./AutoRice.sh
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RICE_DIR="$SCRIPT_DIR/RiceFiles"
LOG_FILE="$HOME/NikoRice/AutoRice_Install.log"

log() { printf '[NikoRice] %s\n' "$*"; }
warn() { printf '[NikoRice] WARNING: %s\n' "$*" >&2; }
fail() { printf '[NikoRice] ERROR: %s\n' "$*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || fail 'Run this script as your normal user, not with sudo or as root.'
[[ -d "$RICE_DIR" ]] || fail "RiceFiles directory not found beside installer: $RICE_DIR"
[[ -r /etc/os-release ]] || fail 'Cannot identify operating system.'
. /etc/os-release
[[ "${ID:-}" == ubuntu ]] || fail "Ubuntu is required (detected ${PRETTY_NAME:-unknown OS})."
command -v sudo >/dev/null 2>&1 || fail 'sudo is required.'

mkdir -p "$(dirname -- "$LOG_FILE")"

# Ensure sudo credentials are available before starting package installation.
sudo -v
log "Installing dependencies on ${PRETTY_NAME:-Ubuntu}. This may take a while."
sudo apt-get update

# Required desktop/runtime dependencies. Separate optional packages so a package
# absent from a particular Ubuntu release does not abort the whole installation.
required=(git feh xorg lightdm python3-pipx i3 i3lock build-essential make zsh rofi picom neofetch scrot imagemagick rxvt-unicode libev-dev libxcb-composite0 libxcb-composite0-dev libxcb-xinerama0 libxcb-randr0 libxcb-xinerama0-dev zip unzip libxcb-xkb-dev libxcb-image0-dev libxcb-util-dev libxkbcommon-x11-dev lightdm-gtk-greeter arandr xbacklight x11-xserver-utils x11-utils curl)
optional=(fonts-hack-ttf virtualbox autoconf rar unrar lightdm-gtk-greeter-settings libjpeg-dev libpam0g-dev)

install_packages() {
    local package
    local missing=()
    for package in "$@"; do
        if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'; then
            continue
        fi
        if ! apt-cache show "$package" >/dev/null 2>&1; then
            missing+=("$package")
        else
            log "Installing $package"
            if ! sudo apt-get install -y --no-install-recommends "$package"; then
                if [[ " $* " == *" $package "* ]]; then
                    warn "Could not install package $package; see apt output above."
                    printf 'Could not install package: %s\n' "$package" >> "$LOG_FILE"
                fi
            fi
        fi
    done
    if ((${#missing[@]})); then
        warn "Unavailable packages skipped: ${missing[*]}"
        printf 'Unavailable packages: %s\n' "${missing[*]}" >> "$LOG_FILE"
    fi
}

install_packages "${required[@]}"
install_packages "${optional[@]}"

# User configuration: back up existing files, then deploy the repository's
# RiceFiles verbatim; do not rewrite the user's custom i3 or shell config.
backup_if_present() {
    local path="$1"
    if [[ -e "$path" || -L "$path" ]]; then
        local backup="${path}.niko-backup.$(date +%Y%m%d%H%M%S)"
        cp -a -- "$path" "$backup"
        log "Backed up $path to $backup"
    fi
}

mkdir -p "$HOME/.config/i3" "$HOME/.config"
for item in baggrunde kommandoer.txt VPN .Xressources; do
    if [[ -e "$RICE_DIR/$item" ]]; then
        backup_if_present "$HOME/$item"
        cp -a -- "$RICE_DIR/$item" "$HOME/"
    else
        warn "Missing RiceFiles/$item; skipped."
    fi
done

for pair in 'config:.config/i3/config' '.zshrc:.zshrc'; do
    source_name="${pair%%:*}"
    target_rel="${pair#*:}"
    target="$HOME/$target_rel"
    [[ -f "$RICE_DIR/$source_name" ]] || fail "Missing RiceFiles/$source_name"
    backup_if_present "$target"
    install -D -m 0644 "$RICE_DIR/$source_name" "$target"
done

# Replace helper scripts as a directory, retaining a backup of an existing one.
if [[ -d "$RICE_DIR/scripts" ]]; then
    backup_if_present "$HOME/.config/scripts"
    cp -a -- "$RICE_DIR/scripts" "$HOME/.config/"
else
    warn 'RiceFiles/scripts not found; helper scripts were skipped.'
fi

if [[ -d "$RICE_DIR/files-dell-bios-fan-control" ]]; then
    backup_if_present "$HOME/files-dell-bios-fan-control"
    cp -a -- "$RICE_DIR/files-dell-bios-fan-control" "$HOME/"
fi

# Oh My Zsh is optional. Its official installer is downloaded and run as the
# user, never as root. Existing installations are left untouched.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    if command -v curl >/dev/null 2>&1 && curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/niko-ohmyzsh-install.sh; then
        RUNZSH=no CHSH=no sh /tmp/niko-ohmyzsh-install.sh --unattended || warn 'Oh My Zsh installation failed; Zsh can still be used without it.'
        rm -f /tmp/niko-ohmyzsh-install.sh
    else
        warn 'Could not download Oh My Zsh; skipped.'
    fi
fi

# Install pywal in pipx's isolated environment (Ubuntu marks system Python as
# externally managed). Use the upstream PyPI package needed by `wal` commands.
export PATH="$HOME/.local/bin:$PATH"
if command -v pipx >/dev/null 2>&1; then
    if ! pipx list --short 2>/dev/null | grep -q '^pywal '; then
        pipx install pywal || { warn 'Could not install pywal with pipx.'; printf 'Could not install pywal with pipx.\n' >> "$LOG_FILE"; }
    fi
else
    warn 'pipx is unavailable; pywal was skipped.'
fi

# System files used by the existing RiceFiles/config. Install only when present.
if [[ -f "$RICE_DIR/i3status.conf" ]]; then
    sudo install -D -m 0644 "$RICE_DIR/i3status.conf" /etc/i3status.conf
fi
if [[ -f "$RICE_DIR/lightdm-gtk-greeter.conf" ]]; then
    if [[ -d /etc/lightdm ]]; then
        # Substitute the user's actual home directory for the greeter config.
        temp_config="$(mktemp)"
        sed "s|\${HOME}|$HOME|g" "$RICE_DIR/lightdm-gtk-greeter.conf" > "$temp_config"
        sudo install -D -m 0644 "$temp_config" /etc/lightdm/lightdm-gtk-greeter.conf
        rm -f "$temp_config"
    else
        warn 'LightDM is not installed; skipped its greeter configuration.'
    fi
fi

# Do not overwrite the system i3lock package with a bundled legacy binary.
# If one is supplied, install separately so the system binary remains intact.
if [[ -f "$RICE_DIR/i3lock" ]]; then
    sudo install -D -m 0755 "$RICE_DIR/i3lock" /usr/local/bin/i3lock-rice
    warn 'Bundled i3lock installed as i3lock-rice; existing config still calls i3lock. Verify the bundled binary before using its custom options.'
fi

# Set Zsh without prompting when available. This may ask for sudo only if the
# user's credentials have expired.
if command -v zsh >/dev/null 2>&1; then
    zsh_path="$(command -v zsh)"
    if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]]; then
        if ! sudo chsh -s "$zsh_path" "$USER"; then
            warn "Could not set Zsh as the default shell; run: chsh -s $zsh_path"
            printf 'Could not set Zsh as default shell.\n' >> "$LOG_FILE"
        fi
    fi
fi

log 'Setup is complete. Log out and choose the i3 session (X11) at the login screen.'
log 'Reboot or log out/in to apply the session and shell changes. No automatic reboot was performed.'
