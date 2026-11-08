#!/usr/bin/env bash
# One-command installer for the NikoRice i3/X11 setup.
# Use: bash ./AutoRice.sh [--unattended]
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RICE_DIR="$SCRIPT_DIR/RiceFiles"
LOG_FILE="$HOME/NikoRice/AutoRice_Install.log"
UNATTENDED=0

for arg in "$@"; do
    case "$arg" in
        --unattended) UNATTENDED=1 ;;
        --help|-h)
            echo "Usage: bash ./AutoRice.sh [--unattended]"
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            echo "Usage: bash ./AutoRice.sh [--unattended]" >&2
            exit 1
            ;;
    esac
done

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
USER_ID="$(id -u)"
GROUP_ID="$(id -g)"

if [[ "$UNATTENDED" -eq 1 ]]; then
    export DEBIAN_FRONTEND=noninteractive
fi
sudo -v
log "Installing dependencies on ${PRETTY_NAME:-Ubuntu}. This may take a while."
sudo apt-get update

# DejaVu Sans Mono is the supported default font used by the configs.
# python3-venv bootstraps pipx if the Ubuntu package is unavailable.
required=(git feh xorg lightdm python3-venv fonts-dejavu-core i3 i3lock build-essential make zsh rofi picom neofetch scrot imagemagick rxvt-unicode libev-dev libxcb-composite0 libxcb-composite0-dev libxcb-xinerama0 libxcb-randr0 libxcb-xinerama0-dev zip unzip libxcb-xkb-dev libxcb-image0-dev libxcb-util-dev libxkbcommon-x11-dev lightdm-gtk-greeter arandr xbacklight x11-xserver-utils x11-utils curl)
optional=(python3-pipx fonts-hack-ttf virtualbox autoconf rar unrar lightdm-gtk-greeter-settings libjpeg-dev libpam0g-dev)

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
            if ! sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$package"; then
                warn "Could not install package $package; see apt output above."
                printf 'Could not install package: %s\n' "$package" >> "$LOG_FILE"
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

backup_if_present() {
    local path="$1"
    if sudo test -e "$path" || sudo test -L "$path"; then
        local backup="${path}.niko-backup.$(date +%Y%m%d%H%M%S).$$"
        sudo cp -a -- "$path" "$backup"
        sudo chown -R "$USER_ID:$GROUP_ID" "$backup"
        log "Backed up $path to $backup"
    fi
}

copy_user_file() {
    local source="$1" target="$2"
    backup_if_present "$target"
    sudo install -D -m 0644 -o "$USER_ID" -g "$GROUP_ID" "$source" "$target"
}

copy_user_dir() {
    local source="$1" target="$2"
    backup_if_present "$target"
    sudo rm -rf -- "$target"
    sudo install -d -o "$USER_ID" -g "$GROUP_ID" "$(dirname -- "$target")"
    sudo cp -R -- "$source" "$target"
    sudo chown -R "$USER_ID:$GROUP_ID" "$target"
}

sudo install -d -o "$USER_ID" -g "$GROUP_ID" "$HOME/.config/i3" "$HOME/.config"
for item in baggrunde kommandoer.txt VPN .Xressources; do
    if [[ -e "$RICE_DIR/$item" ]]; then
        if [[ -d "$RICE_DIR/$item" ]]; then
            copy_user_dir "$RICE_DIR/$item" "$HOME/$item"
        else
            copy_user_file "$RICE_DIR/$item" "$HOME/$item"
        fi
    else
        warn "Missing RiceFiles/$item; skipped."
    fi
done

# Install custom i3 config with portable paths, current compositor and an
# installed, broadly available font family.
i3_config="$(mktemp)"
sed \
    -e 's/^[[:space:]]*exec --no-startup-id compton$/exec --no-startup-id picom/' \
    -e "s|/home/a/.config/scripts/|$HOME/.config/scripts/|g" \
    -e 's/font pango:Hack 8/font pango:DejaVu Sans Mono 8/' \
    "$RICE_DIR/config" > "$i3_config"
copy_user_file "$i3_config" "$HOME/.config/i3/config"
rm -f -- "$i3_config"

copy_user_file "$RICE_DIR/.zshrc" "$HOME/.zshrc"
if [[ -d "$RICE_DIR/scripts" ]]; then
    copy_user_dir "$RICE_DIR/scripts" "$HOME/.config/scripts"
else
    warn 'RiceFiles/scripts not found; helper scripts were skipped.'
fi
if [[ -d "$RICE_DIR/files-dell-bios-fan-control" ]]; then
    copy_user_dir "$RICE_DIR/files-dell-bios-fan-control" "$HOME/files-dell-bios-fan-control"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    installer="$(mktemp)"
    if command -v curl >/dev/null 2>&1 && curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o "$installer"; then
        RUNZSH=no CHSH=no sh "$installer" --unattended || warn 'Oh My Zsh installation failed; Zsh can still be used without it.'
    else
        warn 'Could not download Oh My Zsh; skipped.'
    fi
    rm -f -- "$installer"
fi

export PATH="$HOME/.local/bin:$HOME/.local/share/niko-pipx/bin:$PATH"
if ! command -v pipx >/dev/null 2>&1; then
    bootstrap="$HOME/.local/share/niko-pipx"
    if [[ ! -x "$bootstrap/bin/pipx" ]]; then
        python3 -m venv "$bootstrap" || fail 'Could not create pipx bootstrap environment. Ensure python3-venv is installed.'
        "$bootstrap/bin/python" -m pip install --upgrade pip pipx || fail 'Could not bootstrap pipx in the isolated virtual environment.'
    fi
    export PATH="$bootstrap/bin:$PATH"
fi
if command -v pipx >/dev/null 2>&1; then
    if ! command -v wal >/dev/null 2>&1 || ! wal --help >/dev/null 2>&1; then
        pipx install --force pywal || fail 'Could not install pywal; see the pipx error above.'
    fi
    hash -r
    export PATH="$HOME/.local/bin:$PATH"
    if ! command -v wal >/dev/null 2>&1 || ! wal --help >/dev/null 2>&1; then
        fail 'pywal installation did not provide a working wal command.'
    fi
else
    fail 'pipx is unavailable; cannot install pywal.'
fi

if [[ -f "$RICE_DIR/i3status.conf" ]]; then
    sudo install -D -m 0644 "$RICE_DIR/i3status.conf" /etc/i3status.conf
fi
if [[ -f "$RICE_DIR/lightdm-gtk-greeter.conf" ]]; then
    if [[ -d /etc/lightdm ]]; then
        temp_config="$(mktemp)"
        sed "s|\${HOME}|$HOME|g" "$RICE_DIR/lightdm-gtk-greeter.conf" > "$temp_config"
        sudo install -D -m 0644 "$temp_config" /etc/lightdm/lightdm-gtk-greeter.conf
        rm -f "$temp_config"
    else
        warn 'LightDM is not installed; skipped its greeter configuration.'
    fi
fi

if [[ -f "$RICE_DIR/i3lock" ]]; then
    sudo install -D -m 0755 "$RICE_DIR/i3lock" /usr/local/bin/i3lock-rice
    warn 'Bundled i3lock installed as i3lock-rice; existing config still calls i3lock. Verify the bundled binary before using its custom options.'
fi

if command -v zsh >/dev/null 2>&1; then
    zsh_path="$(command -v zsh)"
    if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]]; then
        if ! sudo chsh -s "$zsh_path" "$USER"; then
            warn "Could not set Zsh as the default shell; run: chsh -s $zsh_path"
            printf 'Could not set Zsh as default shell.\n' >> "$LOG_FILE"
        fi
    fi
fi

if command -v i3 >/dev/null 2>&1; then
    i3 -C -c "$HOME/.config/i3/config" || fail 'The installed i3 config failed validation; inspect its reported line.'
fi

log 'Setup is complete. The i3 and URxvt configs use DejaVu Sans Mono, installed by this script.'
log 'Log out and choose the i3 session from the login screen. Reboot if needed; the installer does not reboot automatically.'
