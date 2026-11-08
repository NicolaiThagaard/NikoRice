# Ubuntu desktop installer (i3/X11)

NikoRice installs an i3-based, terminal-focused desktop setup on Ubuntu. The setup expects an X11 session; it does not replace or configure a Wayland GNOME session.

## One-script installation

```bash
git clone https://github.com/NicolaiThagaard/NikoRice.git
cd NikoRice
bash ./AutoRice.sh --unattended
```

The installer installs packages, deploys the existing `RiceFiles` configuration and scripts, installs system config files and pywal, and configures Zsh when available. It uses DejaVu Sans Mono and verifies pywal before reporting success.

URxvt uses a 32-bit visual and its own transparent background, so the text glyphs stay opaque instead of fading with the entire window. Picom blurs the background behind the terminal and URxvt shading darkens it slightly for readability. There is intentionally no whole-window opacity rule. Blur requires a working GLX-capable picom compositor in an X11 session.

Before replacing a destination, the installer creates a `.niko-backup.<timestamp>` backup. Do not run it with `sudo`; it requests sudo only for package and system-file operations. The installer does not reboot automatically. When it finishes, log out and select **i3** (X11) from the session menu on the login screen.
