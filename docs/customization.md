# Customization

This repository includes helper scripts for adjusting your macOS-like Linux desktop after installation.

## Theme switching

Use the theme switcher to toggle between light and dark mode and apply an accent color:

```bash
cd macos-theme-for-linux
./scripts/theme_switcher.sh --dark --accent=blue
```

Supported accent colors:

- `blue`
- `purple`
- `pink`
- `red`
- `orange`
- `yellow`
- `green`

## Plank dock configuration

If you want to reapply the dock configuration, run:

```bash
./scripts/dock_configurator.sh "$HOME" dark
```

That script will create the macOS-style Plank theme and restart the dock.

## Sound effects

Enable or disable macOS-style sound effects with the sound helper:

```bash
./scripts/sound_effects.sh install
./scripts/sound_effects.sh enable
./scripts/sound_effects.sh disable
```

## Theme configuration file

The installer writes a simple configuration file at:

```bash
~/.config/macos-theme-config.conf
```

This file stores the selected theme mode and accent color so helper scripts can keep settings in sync.
