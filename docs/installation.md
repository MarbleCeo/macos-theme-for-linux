# Installation

## Prerequisites

Before installing, make sure you have:

- A supported Linux distribution with one of the package managers: `apt`, `dnf`, `pacman`, or `zypper`
- `sudo` access
- A desktop environment such as GNOME, XFCE, Cinnamon, MATE, or KDE/Plasma
- A working network connection for downloading themes, icons, wallpapers, and optional sounds

## Quick install

```bash
git clone https://github.com/marbleceo/macos-theme-for-linux.git
cd macos-theme-for-linux
sudo ./install.sh
```

## Supported installer options

- `--interactive`
  - Run the installer in interactive mode and choose installation type, theme mode, and accent color.
- `--minimal`
  - Install only the GTK theme, icon theme, Plank dock configuration, and wallpapers.
- `--complete`
  - Install all components including sound effects.
- `--dark`
  - Use the dark theme mode by default.
- `--accent=<color>`
  - Set the theme accent color. Supported values: `blue`, `purple`, `pink`, `red`, `orange`, `yellow`, `green`.
- `--no-wallpapers`
  - Do not download or install wallpapers.
- `--no-sounds`
  - Do not install sound effects.
- `--no-dock`
  - Do not configure the Plank dock.
- `--help`
  - Show installer usage information.

## Recommended install examples

Install the full suite with the dark theme and purple accents:

```bash
sudo ./install.sh --complete --dark --accent=purple
```

Install only the visual theme and dock without sound effects:

```bash
sudo ./install.sh --minimal
```

## Post-install notes

- Log out and log back in after installation for the theme changes to apply cleanly.
- On KDE/Plasma, some theme changes may require manual application through System Settings.
- If a theme or icon update does not appear immediately, restart the desktop session or run `plank` again.
