# Compatibility

## Supported package managers

- `apt` (Ubuntu, Debian, Pop!_OS, Linux Mint)
- `dnf` (Fedora)
- `pacman` (Arch, Manjaro)
- `zypper` (openSUSE)

## Supported desktop environments

- GNOME
- XFCE
- Cinnamon
- MATE
- KDE / Plasma (partial)

## Notes

- KDE / Plasma support is partial because some theme settings require manual application in System Settings.
- The installer can still download themes and configure Plank on other environments, but automatic theme activation may be limited.
- If a desktop environment is not detected, you may need to apply `WhiteSur` themes manually.
- Use `--no-dock` if Plank is not available or if dock configuration is not desired.

## Tested on

- Ubuntu 22.04
- Linux Mint 21
- Debian 12
- Fedora 38
- Manjaro

## Known limitations

- Some accent variants may not be available in every version of the WhiteSur theme.
- Sound support depends on desktop environment sound-theme compatibility.
