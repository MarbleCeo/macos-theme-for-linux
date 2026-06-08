# Troubleshooting

## General checks

- Verify the installer ran with `sudo`.
- Review the install output for warnings or errors.
- Confirm that the required package manager is available on your system.
- Log out and back in after installation.

## Theme not applying

- On GNOME/Cinnamon/MATE/XFCE, use `gsettings` or the desktop settings tool to check the current theme.
- On KDE/Plasma, some theme changes may require manual application in System Settings.
- Restart the session or reboot if the theme remains inconsistent.

## Plank not starting

- Run `plank` manually to see any errors.
- Ensure `plank` is installed by checking `command -v plank`.
- If Plank starts but does not show the macOS theme, re-run:

```bash
./scripts/dock_configurator.sh "$HOME" light
```

## Sound effects do not work

- Make sure `ffmpeg` is installed if the installer converts sound files.
- Run:

```bash
./scripts/sound_effects.sh install
./scripts/sound_effects.sh enable
```

- Check that your desktop environment supports custom sound themes.

## Unsupported desktop environments

If your environment is not detected correctly, the installer may still place files in your home directory, but automatic theme application may not work. In that case, use your desktop settings tool to apply the `WhiteSur` GTK and icon themes manually.
