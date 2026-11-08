#!/usr/bin/env bash
# Launch picom with blur for translucent URxvt backgrounds.
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/picom"
config_file="$config_dir/nikorice.conf"
mkdir -p "$config_dir"

cat > "$config_file" <<'PICOM_CONFIG'
# No whole-window opacity rule: terminal glyphs remain opaque/readable.
# URxvt's own alpha background is 80% opaque (20% transparent); blur is
# applied behind its transparent pixels.
backend = "glx";
blur-method = "dual_kawase";
blur-strength = 5;
blur-background = true;
blur-background-frame = true;
PICOM_CONFIG

exec picom --config "$config_file"
