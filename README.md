# Ubuntu desktop installer (i3/X11)

NikoRice installs an i3-based, terminal-focused desktop setup on Ubuntu. The setup expects an X11 session; it does not replace or configure a Wayland GNOME session.

## One-script installation

Clone the repository and run the installer as your normal user:

```bash
git clone https://github.com/NicolaiThagaard/NikoRice.git
cd NikoRice
bash ./AutoRice.sh
```

`AutoRice.sh` performs the package installation, deploys the repository's existing `RiceFiles` configuration, installs the system config files and pywal, and configures Zsh when available. It asks for sudo authentication as needed, but otherwise runs without interactive install/reboot prompts. It does **not** reboot automatically. When it finishes, log out and select **i3** (X11) at the login screen; reboot if needed.

The installer backs up existing files before replacing them, with names ending in `.niko-backup.<timestamp>`. It deploys `RiceFiles/config` and `RiceFiles/.zshrc` as stored in the repository; customize those source files before running the installer if you want different settings. Some optional packages are unavailable in certain Ubuntu repositories and will be reported/skipped. LightDM setup is skipped if LightDM is not installed.

Review scripts before running them. The installer uses apt to install software and sudo to write system configuration. It does not upgrade the whole operating system. Installation warnings are recorded in `~/NikoRice/AutoRice_Install.log`.

The older `AutoRice_part1.sh`, `AutoRice_part2.sh`, and `AutoRice_part3.sh` scripts remain available, but a fresh install should use the single `AutoRice.sh` script.

## Notes

- This is an i3/X11 setup, not a Wayland configuration.
- Hardware-specific helper scripts (such as Dell fan control) should only be used on supported hardware.
- `RiceFiles/scripts` contains helper scripts and `RiceFiles/baggrunde` contains wallpapers.
