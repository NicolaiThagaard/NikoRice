# Ubuntu desktop installer (i3/X11)

NikoRice installs an i3-based, terminal-focused desktop setup on Ubuntu. The setup expects an X11 session; it does not replace or configure a Wayland GNOME session.

## One-script installation

```bash
git clone https://github.com/NicolaiThagaard/NikoRice.git
cd NikoRice
bash ./AutoRice.sh --unattended
```

The installer installs packages, deploys the existing `RiceFiles` configuration, installs system config files and pywal, and configures Zsh when available. It uses DejaVu Sans Mono for both i3 and URxvt and installs `fonts-dejavu-core`, avoiding dependence on Hack font package availability. It also repairs root-owned destination files, bootstraps pipx if needed, verifies `wal`, and adjusts old compositor/home-directory paths in the deployed i3 config.

Before replacing a destination, the installer creates a `.niko-backup.<timestamp>` backup. Do not run it with `sudo`; it requests sudo only for package and system-file operations. Some optional packages may be unavailable in the enabled Ubuntu repositories and will be reported/skipped. LightDM setup is skipped if LightDM is not installed.

The installer does not reboot automatically. When it finishes, log out and select **i3** (X11) from the session menu on the login screen. Installing i3 does not automatically switch the current desktop session to i3.

Warnings are recorded in `~/NikoRice/AutoRice_Install.log`. Review scripts before running them.
