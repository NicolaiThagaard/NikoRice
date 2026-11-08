#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RICE_DIR="$SCRIPT_DIR/RiceFiles"

RED='\033[0;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'

if [[ $EUID -eq 0 ]]; then
    printf '%bPlease run this script as your normal user, not root.%b\n' "$RED" "$WHITE" >&2
    exit 1
fi
if [[ ! -d "$RICE_DIR" ]]; then
    printf 'RiceFiles was not found next to this script: %s\n' "$RICE_DIR" >&2
    exit 1
fi

log_file="$HOME/NikoRice/AutoRice_Install.log"
mkdir -p "$(dirname -- "$log_file")"
log_failure() { printf '%s\n' "$*" | tee -a "$log_file" >&2; }

# Install Oh My Zsh only when it is missing; use the current upstream project.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    if command -v curl >/dev/null 2>&1; then
        installer="$(mktemp)"
        if curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o "$installer"; then
            RUNZSH=no CHSH=no sh "$installer" --unattended || log_failure 'Oh My Zsh installation failed.'
        else
            log_failure 'Could not download the Oh My Zsh installer.'
        fi
        rm -f -- "$installer"
    else
        log_failure 'curl is unavailable; skipping Oh My Zsh installation.'
    fi
fi

mkdir -p "$HOME/.config/i3" "$HOME/.config"
copy_items=(baggrunde kommandoer.txt VPN .Xressources)
for item in "${copy_items[@]}"; do
    if [[ -e "$RICE_DIR/$item" ]]; then
        cp -a -- "$RICE_DIR/$item" "$HOME/" || log_failure "Could not copy $item into $HOME."
    else
        log_failure "Missing installer file: $RICE_DIR/$item"
    fi
done

cp -a -- "$RICE_DIR/config" "$HOME/.config/i3/config" || log_failure 'Could not install the i3 config.'
cp -a -- "$RICE_DIR/scripts" "$HOME/.config/" || log_failure 'Could not install the scripts.'
if [[ -d "$RICE_DIR/files-dell-bios-fan-control" ]]; then
    cp -a -- "$RICE_DIR/files-dell-bios-fan-control" "$HOME/" || log_failure 'Could not copy Dell fan-control files.'
fi

# Keep any existing shell configuration instead of deleting it.
if [[ -e "$HOME/.zshrc" ]]; then
    cp -a -- "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"
fi
cp -a -- "$RICE_DIR/.zshrc" "$HOME/.zshrc" || log_failure 'Could not install .zshrc.'

# pipx creates an isolated environment and avoids Ubuntu's PEP 668 restriction
# on installing packages into the system-managed Python environment.
export PATH="$HOME/.local/bin:$PATH"
if command -v pipx >/dev/null 2>&1; then
    if ! pipx install pywal; then
        pipx upgrade pywal || log_failure 'Could not install pywal with pipx.'
    fi
else
    log_failure 'pipx is unavailable. Install python3-pipx, then run: pipx install pywal'
fi

if command -v xrdb >/dev/null 2>&1 && [[ -f "$HOME/.Xressources" ]]; then
    xrdb "$HOME/.Xressources" || log_failure 'xrdb could not load ~/.Xressources (this is normal outside an X11 session).'
fi
if command -v wal >/dev/null 2>&1 && [[ -f "$HOME/baggrunde/macro.png" ]]; then
    wal -i "$HOME/baggrunde/macro.png" -a 80 || log_failure 'pywal could not set the wallpaper.'
fi

printf '\nPart 2 is complete. Reboot and select i3 at the login screen before running part 3.\n'
read -r -p 'Reboot now? (y/n) ' answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo systemctl reboot
fi
