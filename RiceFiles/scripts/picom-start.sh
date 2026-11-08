#!/usr/bin/env bash
# Start picom with a dedicated NikoRice config that applies 80% opacity to URxvt.
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/picom"
config_file="$config_dir/nikorice.conf"
mkdir -p "$config_dir"

cat > "$config_file" <<'PICOM_CONFIG'
# NikoRice: keep URxvt translucent while preserving other window opacity.
opacity-rule = [
  "80:class_g = 'URxvt'"
];
PICOM_CONFIG

exec picom --config "$config_file"
