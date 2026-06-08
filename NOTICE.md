# Attribution & Notices

## Project Composition

**macOS Theme for Linux** is an automated installer that combines multiple open-source projects into a unified macOS-inspired desktop experience for Linux.

---

## Third-Party Components

### WhiteSur GTK Theme & Icons
- **Creator:** [vinceliuice](https://github.com/vinceliuice)
- **Repository:** [vinceliuice/WhiteSur-gtk-theme](https://github.com/vinceliuice/WhiteSur-gtk-theme)
- **License:** GPL-3.0
- **Description:** Modern GTK theme and icon set inspired by macOS Big Sur
- **Used:** GTK3/GTK4 theme application with multiple accent colors

### Capitaine Cursors
- **Cursor theme** for macOS-style mouse pointer
- **Automatically installed** during setup

### Plank Dock
- **The Dock Application** for Linux
- **Description:** Elegant, simple, clean dock
- **Configuration:** Customized with macOS appearance settings

---

## macOS Theme for Linux

- **Developer:** [MarbleCeo](https://github.com/MarbleCeo)
- **Repository:** [MarbleCeo/macos-theme-for-linux](https://github.com/MarbleCeo/macos-theme-for-linux)
- **License:** MIT
- **Description:** Automated installer and configuration manager

### Original Work by MarbleCeo

All installation scripts, configuration logic, automation, and user interface design were created by MarbleCeo, including:

- `install.sh` - Main installation orchestrator
- `scripts/theme_switcher.sh` - Runtime theme switching
- `scripts/dock_configurator.sh` - Dock customization
- `scripts/sound_effects.sh` - Sound integration
- `scripts/pre-install-check.sh` - System validation
- `scripts/theme_installer.sh` - Theme application
- `uninstall.sh` - Clean removal
- Complete documentation suite
- Multi-DE support implementation (GNOME, XFCE, Cinnamon, MATE, KDE/Plasma)
- Multi-package manager support (apt, dnf, pacman, zypper)

---

## License Compatibility

This project uses components under different licenses:

- **macOS Theme for Linux scripts:** MIT License
- **WhiteSur components:** GPL-3.0 License
- **Other components:** Their respective licenses

Users should comply with all applicable licenses when using this project.

---

## Credits

This project would not be possible without the excellent work of:

- **vinceliuice** - For creating the beautiful WhiteSur GTK theme and icons
- The open-source community - For creating Plank, Capitaine Cursors, and other tools
- All contributors and users who provide feedback and improvements

---

## How This Project Adds Value

macOS Theme for Linux simplifies the installation and configuration of existing open-source components by:

1. **Automated Installation** - One-command setup across multiple Linux distributions
2. **Multi-DE Support** - Automatic detection and configuration for different desktop environments
3. **Package Manager Support** - Works with apt, dnf, pacman, and zypper
4. **Complete Integration** - Combines themes, icons, cursors, dock, wallpapers, and sounds
5. **Configuration Management** - Persistent settings and easy theme switching
6. **User Experience** - Professional documentation and error handling
7. **Customization** - 7 accent colors, light/dark modes, selective component installation

---

**Project Status:** v1.0.0 - Stable Release  
**Last Updated:** 2026-06-08  
**Maintained by:** MarbleCeo
