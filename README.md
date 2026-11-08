# Ubuntu desktop installer (i3/X11)

NikoRice installs an i3-based, terminal-focused desktop setup on Ubuntu. The setup expects an X11 session; it does not replace or configure a Wayland GNOME session.

## One-script installation

Clone the repository and run the installer as your normal user:

```bash
git clone https://github.com/NicolaiThagaard/NikoRice.git
cd NikoRice
bash ./AutoRice.sh --unattended
```

The installer installs packages, deploys the existing `RiceFiles` configuration, installs system config files and pywal, and configures Zsh when available. It does not reboot automatically. When it finishes, log out and select **i3** (X11) from the session menu on the login screen. Installing i3 does not automatically switch the current desktop session to i3.

Before replacing a destination, the installer creates a `.niko-backup.<timestamp>` backup. It also repairs ownership on deployed home-directory files, including files left root-owned by earlier install attempts. Do not run it with `sudo`; it requests sudo only for package and system-file operations. It deploys `RiceFiles/config` and `RiceFiles/.zshrc` as stored in the repository. Some optional packages may be unavailable in the enabled Ubuntu repositories and will be reported/skipped. LightDM setup is skipped if LightDM is not installed.

Review scripts before running them. The installer uses apt to install software and sudo to write system configuration. It does not upgrade the whole operating system. Warnings are recorded in `~/NikoRice/AutoRice_Install.log`.

The older `AutoRice_part1.sh`, `AutoRice_part2.sh`, and `AutoRice_part3.sh` scripts remain available, but a fresh install or repair should use the single `AutoRice.sh` script.

## Notes

- This is an i3/X11 setup, not a Wayland configuration.
- Hardware-specific helper scripts (such as Dell fan control) should only be used on supported hardware.
- `RiceFiles/scripts` contains helper scripts and `RiceFiles/baggrunde` contains wallpapers.
