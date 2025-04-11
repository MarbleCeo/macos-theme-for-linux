# 🍎 macOS Theme Suite for Linux

<p align="center">
  <img src="https://raw.githubusercontent.com/vinceliuice/WhiteSur-gtk-theme/master/screenshots/screenshot-01.png" alt="macOS Theme for Linux Banner" width="800">
</p>

<p align="center">
  <b>Transform your Linux desktop into a complete macOS-like environment with enhanced features and polish!</b>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-customization">Customization</a> •
  <a href="#%EF%B8%8F-themes">Themes</a> •
  <a href="#-documentation">Documentation</a>
</p>

## ✨ Features

Our enhanced macOS theme suite goes beyond the basics to provide a truly immersive macOS-like experience on Linux:

- 🎨 **Complete WhiteSur GTK Theme** (Light/Dark modes with accent colors)
- 🖌️ **WhiteSur Icon Theme** with macOS-style application icons
- 🚀 **Advanced Plank Dock** with realistic macOS animations and behavior
- 🔍 **Spotlight-inspired Application Launcher**
- 🎵 **Authentic macOS Sound Effects** (startup, alerts, UI interactions)
- 🖥️ **Dynamic Wallpaper** that changes based on time of day (like in macOS)
- 🔤 **SF Pro Font Integration** for authentic Apple typography
- 🧰 **Finder-like File Manager Customizations**
- ⚡ **Window Management Gestures** for trackpad users
- 🔄 **Auto-update mechanism** to keep your theme current

## 🚀 Installation

### One-Command Installation

```bash
git clone https://github.com/marbleceo/macos-theme-for-linux.git && cd macos-theme-for-linux && sudo ./install.sh
```

### Interactive Installation (Recommended)

For more control over what gets installed:

```bash
git clone https://github.com/marbleceo/macos-theme-for-linux.git
cd macos-theme-for-linux
sudo ./install.sh --interactive
```

### Options

| Option | Description |
|--------|-------------|
| `--interactive` | Interactive installation with customization options |
| `--minimal` | Install only essential components (theme and icons) |
| `--complete` | Install all components including sounds and fonts |
| `--dark` | Set dark mode as default |
| `--accent=COLOR` | Set accent color (blue, purple, pink, red, orange, yellow, green) |

## 🎛️ Customization

### Theme Switcher

Switch between light and dark mode with our included theme switcher:

```bash
./scripts/theme_switcher.sh --dark   # Switch to dark mode
./scripts/theme_switcher.sh --light  # Switch to light mode
```

### Dynamic Wallpaper

Enable the dynamic wallpaper feature that changes throughout the day:

```bash
./scripts/enable_dynamic_wallpaper.sh
```

### Sound Effects

Enable or disable macOS sound effects:

```bash
./scripts/sound_effects.sh --enable
./scripts/sound_effects.sh --disable
```

## 🖌️ Themes

Choose from multiple theme variants:

- **WhiteSur Light** - Classic light appearance
- **WhiteSur Dark** - Sleek dark appearance
- **WhiteSur Accent Colors** - Customize with various accent colors:
  - Blue (Default)
  - Purple
  - Pink
  - Red
  - Orange
  - Yellow
  - Green

## 📚 Documentation

Comprehensive documentation is available in the `docs` directory:

- [Installation Guide](docs/installation.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Customization Options](docs/customization.md)
- [Desktop Environment Compatibility](docs/compatibility.md)
- [Theme Development](docs/development.md)

## 🖥️ Compatibility

This theme suite has been thoroughly tested on:

| Distribution | Desktop Environments | Status |
|--------------|----------------------|--------|
| Ubuntu 20.04+ | GNOME, XFCE, Unity, Budgie | ✅ Full Support |
| Linux Mint | Cinnamon, MATE, XFCE | ✅ Full Support |
| Debian 11+ | GNOME, XFCE, Cinnamon | ✅ Full Support |
| Fedora | GNOME, XFCE, Cinnamon | ✅ Full Support |
| Manjaro | XFCE, KDE, GNOME | ✅ Full Support |
| Pop!_OS | GNOME, COSMIC | ✅ Full Support |
| Kali Linux | XFCE, GNOME | ✅ Full Support |
| elementary OS | Pantheon | ⚠️ Partial Support |
| Arch Linux | Most DEs | ✅ Full Support |
| openSUSE | KDE, GNOME, XFCE | ✅ Full Support |

## 🛠️ Components

Our theme suite installs the following components:

1. **Core Theme Components**
   - WhiteSur GTK2/3/4 Theme
   - WhiteSur Icon Theme
   - Plank Dock with macOS theme
   - SF Pro Font (optional)

2. **Enhanced Experience**
   - macOS-style cursors
   - macOS sound effects
   - Dynamic wallpapers
   - Spotlight-like application launcher

3. **Configuration Tools**
   - Theme switcher (Light/Dark)
   - Accent color selector
   - Settings backup/restore utility
   - Auto-update script

## 📸 Screenshots

<p align="center">
  <img src="assets/screenshots/desktop.png" width="48%" alt="Desktop Screenshot">
  <img src="assets/screenshots/applications.png" width="48%" alt="Applications Screenshot">
</p>

<p align="center">
  <img src="assets/screenshots/dark-mode.png" width="48%" alt="Dark Mode Screenshot">
  <img src="assets/screenshots/settings.png" width="48%" alt="Settings Screenshot">
</p>

## 🔄 Updates

The theme is actively maintained. To update to the latest version:

```bash
cd macos-theme-for-linux
git pull
sudo ./install.sh --update
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Credits

- [WhiteSur GTK Theme](https://github.com/vinceliuice/WhiteSur-gtk-theme) by vinceliuice
- [WhiteSur Icon Theme](https://github.com/vinceliuice/WhiteSur-icon-theme) by vinceliuice
- Additional components and enhancements by the macOS Theme for Linux team

---

<p align="center">
  Made with ❤️ for the Linux community
</p>

<p align="center">
  <b>Tags:</b> #Linux #macOS #theme #WhiteSur #GTK #Plank #dock #customization #ricing #ubuntu #debian #kali #fedora #mint #manjaro
</p>
