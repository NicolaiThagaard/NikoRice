# Ubuntu desktop installer (i3/X11)

NikoRice installs an i3-based, terminal-focused desktop setup on Ubuntu. The scripts have been updated for current Ubuntu releases, but desktop package availability and LightDM support depend on the Ubuntu flavor and enabled repositories. The setup expects an X11 session; it does not replace or configure a Wayland GNOME session.

The installer modifies your user configuration and installs system packages. Review the scripts before running them, and back up your existing configuration first. Run the scripts from the cloned repository; they now locate `RiceFiles` relative to the script, so the repository does not need to be at `~/NikoRice`.

## Install

```bash
git clone https://github.com/NicolaiThagaard/NikoRice.git
cd NikoRice
bash ./AutoRice_part1.sh
```

Part 1 uses `sudo` to update apt metadata and install available dependencies. It does not upgrade the entire operating system. Some packages (for example VirtualBox or `rar`) may not be available in every Ubuntu repository configuration; unavailable optional packages are reported and skipped.

Run part 2 as your normal user:

```bash
bash ./AutoRice_part2.sh
```

It backs up an existing `~/.zshrc`, installs the user configuration, and installs pywal with `pipx` in an isolated Python environment. If the reboot prompt is declined, reboot manually and select **i3** (an X11 session) at the login screen.

After logging in to i3, run part 3 as your normal user:

```bash
bash ./AutoRice_part3.sh
```

Part 3 uses `sudo` for system configuration, then offers to set Zsh as the default shell. Reboot when prompted to finish.

Install errors are appended to `~/NikoRice/AutoRice_Install.log` when that directory exists; the scripts print warnings directly as well. If the setup fails, include the failing command and its output when reporting the problem.

## Notes

- LightDM is optional for the system configuration step; if it is not installed, its greeter configuration is skipped.
- Some bundled scripts are hardware-specific (for example, Dell fan control) and should only be used on supported hardware.
- `RiceFiles/scripts` contains the helper scripts and `RiceFiles/baggrunde` contains wallpapers.
