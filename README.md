# macOS Theme for Linux

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Release](https://img.shields.io/github/v/release/MarbleCeo/macos-theme-for-linux?include_prereleases)](https://github.com/MarbleCeo/macos-theme-for-linux/releases)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)

**Developed by [MarbleCeo](https://github.com/MarbleCeo)**

macOS Theme for Linux provides an automated installer for a complete macOS-inspired desktop experience on supported Linux systems. Created by MarbleCeo, this project installs the WhiteSur GTK theme, WhiteSur icon theme, Plank dock, wallpapers, and optional sound effects.

## What's Included

- **WhiteSur GTK Theme** with 7 color accents (blue, purple, pink, red, orange, yellow, green)
- **WhiteSur Icon Theme** for consistent visual identity
- **macOS-Style Cursors** (Capitaine Cursors)
- **Plank Dock** with professional macOS appearance
- **Official macOS Wallpapers** (Sonoma light/dark)
- **14+ macOS Sound Effects** with automatic configuration
- **Multi-DE Support:** GNOME, XFCE, Cinnamon, MATE, KDE/Plasma


## Installation

```bash
git clone https://github.com/marbleceo/macos-theme-for-linux.git
cd macos-theme-for-linux
sudo ./install.sh
```

## Installer options

- `--interactive`: run the installer in interactive mode
- `--minimal`: install themes, icons, dock and wallpapers only
- `--complete`: install all components, including sound effects
- `--dark`: set dark mode as default
- `--accent=<color>`: choose accent color (blue, purple, pink, red, orange, yellow, green)
- `--no-wallpapers`: skip wallpaper download
- `--no-sounds`: skip sound effect installation
- `--no-dock`: skip Plank dock configuration
- `--help`: display available options

## Usage examples

Install the complete desktop theme package with dark mode and purple accent:

```bash
sudo ./install.sh --complete --dark --accent=purple
```

Install only the visual theme components without sounds:

```bash
sudo ./install.sh --minimal
```

## Included Helper Scripts

- `./scripts/pre-install-check.sh` - Validates system requirements
- `./scripts/theme_switcher.sh --light|--dark [--accent=<color>]` - Switch themes
- `./scripts/dock_configurator.sh <user-home> <light|dark>` - Reconfigure dock
- `./scripts/sound_effects.sh install|enable|disable` - Manage sounds
- `./uninstall.sh [--force] [--preserve]` - Complete uninstallation

## Documentation

- [Installation](docs/installation.md)
- [Customization](docs/customization.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Compatibility](docs/compatibility.md)

## Compatibility

- Supported package managers: `apt`, `dnf`, `pacman`, `zypper`
- Supported desktop environments: GNOME, XFCE, Cinnamon, MATE, KDE/Plasma (partial)

> KDE/Plasma support is partial and may require manual configuration.

## About

This project was developed by **MarbleCeo** to provide the Linux community with an easy-to-use automated installer for achieving a polished macOS-style desktop. Every script, configuration, and feature in this repository was designed and implemented by MarbleCeo.

## Attribution

This project is based on the following open-source projects and components:

- **WhiteSur GTK Theme** - Created by [vinceliuice](https://github.com/vinceliuice)
  - Repository: [WhiteSur-gtk-theme](https://github.com/vinceliuice/WhiteSur-gtk-theme)
  - License: GPL-3.0
  
- **WhiteSur Icon Theme** - Created by [vinceliuice](https://github.com/vinceliuice)
  - Part of the WhiteSur project
  - License: GPL-3.0

- **Capitaine Cursors** - Cursor theme used
  
- **Plank Dock** - The dock application

This project wraps and automates these components for a seamless all-in-one installation experience on Linux.

## Support the Project

This is currently **FREE and open-source** on GitHub! 

If you find value in this project, you can support its development:
- ⭐ Star this repository
- 🐛 Report issues and suggest features
- 🤝 Contribute code or documentation
- 💰 Optional: Premium version coming soon with advanced features

## Premium Features (Coming Soon)

- All 7 color accents
- Automatic updates
- Advanced configuration options
- Priority support
- License for personal use

**Roadmap:** v1.1.0 will include GitHub Actions CI/CD, GUI installer, and i18n support.


## Credits

- **WhiteSur GTK Theme** by [vinceliuice](https://github.com/vinceliuice/WhiteSur-gtk-theme)
- **macOS Wallpapers** from [512pixels.net](https://512pixels.net/)
- **macOS Sounds** from [petrstepanov/macos-sounds](https://github.com/petrstepanov/macos-sounds)
- **Plank Dock** for the macOS-style dock implementation

## License

Released under the MIT License. See [LICENSE](LICENSE).
