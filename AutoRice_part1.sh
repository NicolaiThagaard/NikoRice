#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'

if [[ $EUID -ne 0 ]]; then
    if ! command -v sudo >/dev/null 2>&1; then
        printf 'This installer needs root privileges, but sudo is not installed.\n' >&2
        exit 1
    fi
    exec sudo --preserve-env=PATH bash "$SCRIPT_DIR/$(basename -- "$0")" "$@"
fi

if [[ ! -r /etc/os-release ]]; then
    echo 'Cannot identify this operating system.' >&2
    exit 1
fi
. /etc/os-release
if [[ "${ID:-}" != ubuntu ]]; then
    printf 'This installer targets Ubuntu; detected %s.\n' "${PRETTY_NAME:-unknown OS}" >&2
    exit 1
fi

printf 'Installing NikoRice dependencies on %s...\n' "${PRETTY_NAME:-Ubuntu}"

# Refresh package metadata only. Avoid automatically upgrading the whole system.
apt-get update

# Ubuntu 24.04+ uses externally managed Python environments. Install pywal
# through pipx in part 2 rather than calling pip against system Python.
packages=(
    git feh xorg lightdm python3-pipx fonts-hack i3 virtualbox autoconf make
    build-essential i3lock rar unrar picom zsh rofi neofetch scrot
    imagemagick rxvt-unicode libev-dev libxcb-composite0 libxcb-composite0-dev
    libxcb-xinerama0 libxcb-randr0 libxcb-xinerama0-dev zip unzip libxcb-xkb-dev
    libxcb-image0-dev libxcb-util-dev libxkbcommon-x11-dev lightdm-gtk-greeter
    arandr lightdm-gtk-greeter-settings libjpeg-dev libpam0g-dev
    xbacklight x11-xserver-utils x11-utils curl
)

failed=()
for package in "${packages[@]}"; do
    if ! apt-cache show "$package" >/dev/null 2>&1; then
        printf '%b[SKIP ]%b Package is not available in the enabled Ubuntu repositories: %s\n' "$RED" "$WHITE" "$package"
        failed+=("$package (unavailable)")
    elif dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'; then
        printf '%b[  OK  ]%b Already installed: %s\n' "$GREEN" "$WHITE" "$package"
    elif apt-get install -y --no-install-recommends "$package"; then
        printf '%b[  OK  ]%b Installed: %s\n' "$GREEN" "$WHITE" "$package"
    else
        printf '%b[FAILED]%b Could not install: %s\n' "$RED" "$WHITE" "$package"
        failed+=("$package")
    fi
done

if ((${#failed[@]})); then
    printf '\nSome optional dependencies were skipped or failed:\n'
    printf '  - %s\n' "${failed[@]}"
    printf 'Install any needed packages manually, then continue with part 2.\n'
fi

printf '\nPart 1 is complete. Run AutoRice_part2.sh as your normal user.\n'
