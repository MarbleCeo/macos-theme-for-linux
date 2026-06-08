# Changelog

All notable changes to this project will be documented in this file.

The format is based on "Keep a Changelog" and this project adheres to Semantic Versioning.

## [1.0.0] - 2026-06-08

### Added
- Complete macOS theme installer with multi-DE support
- WhiteSur GTK theme with 7 color accent options
- WhiteSur icon theme and Capitaine cursors
- Plank dock configuration with light/dark modes
- macOS Sonoma wallpapers (automatic download)
- 14+ macOS sound effects with DE-specific configuration
- Helper scripts: theme_switcher, dock_configurator, sound_effects
- Selective installation options (--no-wallpapers, --no-sounds, --no-dock)
- Pre-installation validation script
- Uninstall script with preservation options
- Comprehensive documentation (5 docs)
- Professional README with badges and credits
- Support for 4 package managers: apt, dnf, pacman, zypper
- Support for 5 desktop environments: GNOME, XFCE, Cinnamon, MATE, KDE/Plasma
- Automatic cursor theme installation
- KDE/Plasma support with kwriteconfig5
- CONTRIBUTING.md and CODE_OF_CONDUCT.md

### Improved
- Plank dock visual: larger icons (56px), better roundness (TopRoundness 8)
- Enhanced transparency (FadeOpacity 0.95) for professional glass effect
- Professional output without emojis
- Better error handling and user feedback
- Configuration persistence in ~/.config/macos-theme-config.conf
- Automatic accent color application from config

## [Unreleased]
- GitHub Actions CI/CD pipeline
- GUI installer (GTK/Qt)
- Internationalization (i18n)
- User-only installation mode
- Theme preview screenshots
- Automated tests in Docker containers
