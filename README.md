# 🍎 macOS Theme for Linux

Transform your Linux desktop into a macOS-like environment with a single command!

![macOS Linux Theme](https://raw.githubusercontent.com/vinceliuice/WhiteSur-gtk-theme/master/screenshots/screenshot-01.png)

## 🚀 One-Command Installation

This installer works on multiple Linux distributions. Simply run:

```bash
git clone https://github.com/marbleceo/macos-theme-for-linux.git && cd macos-theme-for-linux && sudo ./install.sh
```

The installation script will automatically detect your distribution and desktop environment to apply the appropriate configurations.

## ✨ Features

- 🎨 WhiteSur GTK Theme (macOS Big Sur style)
- 🖼️ WhiteSur Icon Theme
- 🚀 Plank Dock (similar to macOS dock)
- ⚡ Automatic configuration
- 🎯 Desktop Environment optimization
- 🖥️ Cross-distribution compatibility

## 🔧 Requirements

- Linux distribution with XFCE, GNOME, Cinnamon, MATE, or KDE desktop environment
- Git
- Internet connection
- sudo privileges

## 🖥️ Compatibility

This theme has been tested and confirmed working on:
- Kali Linux (XFCE)
- Ubuntu 20.04+ (GNOME, XFCE)
- Linux Mint (Cinnamon, MATE, XFCE)
- Debian 11+ (GNOME, XFCE)
- Fedora (GNOME, XFCE)
- Manjaro (XFCE, KDE)

Other distributions based on these should also work but may require minor adjustments.

## 📋 What gets installed

1. Plank dock
2. WhiteSur GTK theme
3. WhiteSur icon theme
4. Required dependencies

## 🛠️ Post-Installation

After installation:
1. Log out and log back in
2. Right-click on Plank dock to customize
3. Add your favorite applications to the dock

## 🎨 Customization

To switch between light and dark themes:
```bash
# For Light theme
xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Light"

# For Dark theme
xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Dark"
```

## 🤝 Credits

- [WhiteSur GTK Theme](https://github.com/vinceliuice/WhiteSur-gtk-theme) by vinceliuice
- [WhiteSur Icon Theme](https://github.com/vinceliuice/WhiteSur-icon-theme) by vinceliuice

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔍 Current Limitations & Future Improvements

While this theme provides a good approximation of the macOS experience, there are some areas that could be improved:

1. **Wallpapers**: The current installation doesn't include authentic macOS-style wallpapers that would complement the theme. We plan to add a collection of macOS-inspired wallpapers in future updates.

2. **System Sounds**: macOS has distinctive system sounds that aren't included in this theme yet.

3. **Animation Effects**: Some of the smooth animations present in macOS are challenging to replicate perfectly in Linux environments.

4. **Font Rendering**: macOS has specific font rendering that gives it a distinct look. We're working on improving font configuration to get closer to this experience.

5. **Application Theming**: While the GTK theme covers most applications, some may not be themed properly, especially non-GTK applications.

## 🐛 Troubleshooting

If you encounter any issues:
1. Ensure you're running a compatible Linux distribution and desktop environment
2. Make sure you have an internet connection
3. Run the installer with sudo privileges
4. For distribution-specific issues, check the compatibility notes above

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Tags**: #Linux #macOS #theme #WhiteSur #GTK #Plank #dock #customization #ricing #ubuntu #debian #kali #fedora #mint #manjaro #XFCE #GNOME #KDE #Cinnamon #MATE
