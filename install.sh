#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# macOS Theme for Linux - Professional Installer
# Version: 1.0.0
# Author: MarbleCeo
# Repository: https://github.com/MarbleCeo/macos-theme-for-linux

VERSION="1.0.0"

usage() {
    cat <<'EOF'
Usage: sudo ./install.sh [OPTIONS]

Options:
  --help             Show this help message
  --interactive      Run the installer in interactive mode
  --minimal          Install themes, icons, dock, and wallpapers only
  --complete         Install all components, including sound effects
  --dark             Use dark theme mode by default
  --accent=<color>   Set the accent color (blue, purple, pink, red, orange, yellow, green)
  --no-wallpapers    Skip wallpaper download
  --no-sounds        Skip sound effect installation
  --no-dock          Skip Plank dock configuration
EOF
}

validate_user() {
    if [ "$EUID" -ne 0 ]; then
        echo "Error: This script requires sudo privileges to install system components."
        exit 1
    fi

    if [ -z "${SUDO_USER:-}" ]; then
        echo "Error: SUDO_USER is not set. Please run: sudo ./install.sh"
        exit 1
    fi
}

prompt() {
    local prompt_text="$1"
    local default_value="$2"
    local result

    read -r -p "$prompt_text [$default_value]: " result
    if [ -z "$result" ]; then
        result="$default_value"
    fi
    echo "$result"
}

detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    else
        echo "unsupported"
    fi
}

install_packages() {
    local manager="$1"
echo "Detected package manager: $manager"

    case "$manager" in
        apt)
            apt update -y
            apt install -y plank git wget unzip sassc libglib2.0-dev-bin curl ffmpeg
            ;;
        dnf)
            dnf check-update || true
            dnf install -y plank git wget unzip sassc glib2-devel curl ffmpeg
            ;;
        pacman)
            pacman -Sy --noconfirm
            pacman -S --noconfirm plank git wget unzip sassc glib2 curl ffmpeg
            ;;
        zypper)
            zypper refresh
            zypper install -y plank git wget unzip sassc glib2-devel curl ffmpeg
            ;;
        *)
            echo "Error: Unsupported package manager. Supported: apt, dnf, pacman, zypper"
            exit 1
            ;;
    esac
}

detect_desktop_env() {
    if [ -n "${XDG_CURRENT_DESKTOP:-}" ]; then
        echo "$XDG_CURRENT_DESKTOP"
    elif [ -n "${XDG_SESSION_DESKTOP:-}" ]; then
        echo "$XDG_SESSION_DESKTOP"
    elif [ -n "${DESKTOP_SESSION:-}" ]; then
        echo "$DESKTOP_SESSION"
    elif pgrep -x "gnome-shell" &> /dev/null; then
        echo "GNOME"
    elif pgrep -x "plasmashell" &> /dev/null; then
        echo "KDE"
    elif pgrep -x "xfce4-session" &> /dev/null; then
        echo "XFCE"
    elif pgrep -x "cinnamon" &> /dev/null; then
        echo "Cinnamon"
    elif pgrep -x "mate-session" &> /dev/null; then
        echo "MATE"
    else
        echo "Unknown"
    fi
}

download_wallpapers() {
    local wallpapers_dir="$1"
    mkdir -p "$wallpapers_dir"

    echo "Downloading macOS wallpapers (this may take a moment)..."
    wget -q -O "$wallpapers_dir/14-0-Light.jpg" "https://512pixels.net/downloads/macos-wallpapers/14-0-Light.jpg" || echo "Warning: Failed to download light wallpaper"
    wget -q -O "$wallpapers_dir/14-0-Dark.jpg" "https://512pixels.net/downloads/macos-wallpapers/14-0-Dark.jpg" || echo "Warning: Failed to download dark wallpaper"
}

install_theme_components() {
    local user_home="$1"
    local theme_mode="$2"
    local accent_color="$3"

    echo "Installing WhiteSur GTK theme..."
    rm -rf /tmp/WhiteSur-gtk-theme
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git /tmp/WhiteSur-gtk-theme

    local install_opts="-t all --dest \"$user_home/.themes\""
    if [ "$theme_mode" = "dark" ]; then
        install_opts="$install_opts --dark"
    fi
    if [ "$accent_color" != "blue" ] && [ -n "$accent_color" ]; then
        install_opts="$install_opts --color $accent_color"
    fi

    eval "/tmp/WhiteSur-gtk-theme/install.sh $install_opts"

    echo "Installing WhiteSur icon theme..."
    rm -rf /tmp/WhiteSur-icon-theme
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git /tmp/WhiteSur-icon-theme
    /tmp/WhiteSur-icon-theme/install.sh --dest "$user_home/.icons"

    echo "Installing macOS-style cursor theme..."
    rm -rf /tmp/macOS-Cursors
    git clone https://github.com/ful1e5/apple_cursor.git /tmp/macOS-Cursors 2>/dev/null || true
    if [ -d "/tmp/macOS-Cursors/dist" ]; then
        mkdir -p "$user_home/.icons/Capitaine Cursors"
        cp -r /tmp/macOS-Cursors/dist/Capitaine-Cursors "$user_home/.icons/" 2>/dev/null || true
    fi
}

create_config_file() {
    local user_home="$1"
    local theme_mode="$2"
    local accent_color="$3"

    mkdir -p "$user_home/.config"
    cat > "$user_home/.config/macos-theme-config.conf" <<EOF
THEME_MODE="$theme_mode"
ACCENT_COLOR="$accent_color"
EOF
}

apply_theme_settings() {
    local desktop_env="$1"
    local user_home="$2"
    local real_user="$3"
    local theme_mode="$4"
    local accent_color="$5"

    local theme_name
    local icon_theme
    local cursor_theme="Capitaine Cursors"

    if [ "$theme_mode" = "dark" ]; then
        theme_name="WhiteSur-Dark"
        icon_theme="WhiteSur-dark"
    else
        theme_name="WhiteSur-Light"
        icon_theme="WhiteSur-light"
    fi

    if [ "$accent_color" != "blue" ] && [ -n "$accent_color" ]; then
        theme_name="${theme_name}-${accent_color}"
    fi

    echo "Applying theme settings for $desktop_env..."

    case "$desktop_env" in
        *XFCE*)
            sudo -u "$real_user" xfconf-query -c xsettings -p /Net/ThemeName -s "$theme_name" 2>/dev/null || true
            sudo -u "$real_user" xfconf-query -c xfwm4 -p /general/theme -s "$theme_name" 2>/dev/null || true
            sudo -u "$real_user" xfconf-query -c xsettings -p /Net/IconThemeName -s "$icon_theme" 2>/dev/null || true
            sudo -u "$real_user" xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "$cursor_theme" 2>/dev/null || true
            ;;
        *GNOME*|*Ubuntu*)
            sudo -u "$real_user" gsettings set org.gnome.desktop.interface gtk-theme "$theme_name" 2>/dev/null || true
            sudo -u "$real_user" gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" 2>/dev/null || true
            sudo -u "$real_user" gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme" 2>/dev/null || true
            ;;
        *KDE*|*Plasma*)
            if command -v kwriteconfig5 &> /dev/null; then
                sudo -u "$real_user" kwriteconfig5 --file ~/.config/kdeglobals --group "General" --key "ColorScheme" "WhiteSur" 2>/dev/null || true
                sudo -u "$real_user" kwriteconfig5 --file ~/.config/kdeglobals --group "General" --key "WidgetStyle" "Breeze" 2>/dev/null || true
                echo "KDE/Plasma: Apply WhiteSur theme manually in System Settings > Appearance for best results."
            else
                echo "KDE/Plasma detected: Apply WhiteSur theme manually in System Settings > Appearance."
            fi
            ;;
        *Cinnamon*)
            sudo -u "$real_user" gsettings set org.cinnamon.desktop.interface gtk-theme "$theme_name" 2>/dev/null || true
            sudo -u "$real_user" gsettings set org.cinnamon.desktop.interface icon-theme "$icon_theme" 2>/dev/null || true
            sudo -u "$real_user" gsettings set org.cinnamon.desktop.interface cursor-theme "$cursor_theme" 2>/dev/null || true
            ;;
        *MATE*)
            sudo -u "$real_user" gsettings set org.mate.interface gtk-theme "$theme_name" 2>/dev/null || true
            sudo -u "$real_user" gsettings set org.mate.interface icon-theme "$icon_theme" 2>/dev/null || true
            sudo -u "$real_user" gsettings set org.mate.interface cursor-theme "$cursor_theme" 2>/dev/null || true
            ;;
        *)
            echo "Desktop environment not detected. Apply WhiteSur theme manually in your desktop settings."
            ;;
    esac
}

create_plank_autostart() {
    local user_home="$1"
    mkdir -p "$user_home/.config/autostart"
    cat > "$user_home/.config/autostart/plank.desktop" <<'END'
[Desktop Entry]
Type=Application
Name=Plank
Comment=macOS-style Dock
Exec=plank
Icon=plank
Terminal=false
Categories=Utility;
X-GNOME-Autostart-enabled=true
END
}

create_plank_theme() {
    local user_home="$1"
    local theme_mode="$2"
    local plank_dir="$user_home/.config/plank"
    local theme_dir="$plank_dir/themes/macOS"

    mkdir -p "$theme_dir"
    mkdir -p "$plank_dir/dock1"

    if [ "$theme_mode" = "dark" ]; then
        fill_color="30;;30;;30"
        stroke_color="20;;20;;20"
        outer_stroke="15;;15;;15;;255"
    else
        fill_color="245;;245;;245"
        stroke_color="225;;225;;225"
        outer_stroke="180;;180;;180;;200"
    fi

    cat > "$theme_dir/dock.theme" <<END
[PlankTheme]
TopRoundness=8
BottomRoundness=0
LineWidth=1
OuterStrokeColor=${outer_stroke}
FillStartColor=${fill_color};;240
FillEndColor=${fill_color};;240
InnerStrokeColor=${stroke_color};;200

[PlankDockTheme]
HorizPadding=8
TopPadding=4
BottomPadding=6
ItemPadding=6
IndicatorSize=6
IconShadowSize=2
UrgentBounceHeight=1.8
LaunchBounceHeight=0.7
FadeOpacity=0.95
ClickTime=300
UrgentBounceTime=600
LaunchBounceTime=600
ActiveTime=300
SlideTime=300
FadeTime=250
HideTime=250
GlowSize=35
GlowTime=10000
GlowPulseTime=2000
UrgentHueShift=150
ItemMoveTime=450
CascadeHide=true
END

    cat > "$plank_dir/dock1/settings" <<'END'
[PlankDockPreferences]
CurrentWorkspaceOnly=false
IconSize=56
HideMode=1
UnhideDelay=0
Monitor=-1
DockItems=plank.dockitem;;trash.dockitem
Position=3
Offset=0
Theme=macOS
Alignment=3
LockItems=false
PressureReveal=false
PinnedOnly=false
AutoPinning=true
ShowDockItem=false
ZoomEnabled=true
ZoomPercent=165
END

    echo "[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/plank.desktop" > "$plank_dir/dock1/plank.dockitem"
    echo "[PlankDockItemPreferences]
Launcher=trash://" > "$plank_dir/dock1/trash.dockitem"
}

start_plank() {
    local real_user="$1"
    if command -v plank &> /dev/null; then
        echo "🚀 Starting Plank dock..."
        sudo -u "$real_user" DISPLAY=:0 plank &> /dev/null || true
    fi
}

main() {
    validate_user

    local interactive=false
    local installation_mode="complete"
    local theme_mode="light"
    local accent_color="blue"
    local install_wallpapers=true
    local install_sounds=true
    local configure_dock=true

    while [ "$#" -gt 0 ]; do
        case "$1" in
            --help)
                usage
                exit 0
                ;;
            --interactive)
                interactive=true
                shift
                ;;
            --minimal)
                installation_mode="minimal"
                shift
                ;;
            --complete)
                installation_mode="complete"
                shift
                ;;
            --dark)
                theme_mode="dark"
                shift
                ;;
            --accent=*)
                accent_color="${1#*=}"
                shift
                ;;
            --no-wallpapers)
                install_wallpapers=false
                shift
                ;;
            --no-sounds)
                install_sounds=false
                shift
                ;;
            --no-dock)
                configure_dock=false
                shift
                ;;
            *)
                echo "Error: Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    if [ "$interactive" = true ]; then
        installation_mode="$(prompt 'Install mode (complete/minimal)' 'complete')"
        theme_mode="$(prompt 'Theme mode (light/dark)' 'light')"
        accent_color="$(prompt 'Accent color (blue/purple/pink/red/orange/yellow/green)' 'blue')"
    fi

    if [ "$installation_mode" = "minimal" ]; then
        install_sounds=false
    fi

    local package_manager
    package_manager="$(detect_package_manager)"
    install_packages "$package_manager"

    local user_home
    user_home="$(eval echo ~$SUDO_USER)"
    local real_user="$SUDO_USER"
    local desktop_env
    desktop_env="$(detect_desktop_env)"

    echo "Installing macOS Theme Suite for Linux..."
    echo "Detected desktop environment: $desktop_env"

    mkdir -p "$user_home/.themes" "$user_home/.icons" "$user_home/.config/autostart" "$user_home/Pictures/Wallpapers/macOS"

    if [ "$install_wallpapers" = true ]; then
        download_wallpapers "$user_home/Pictures/Wallpapers/macOS"
    else
        echo "Skipping wallpaper download."
    fi

    install_theme_components "$user_home" "$theme_mode" "$accent_color"

    if [ "$configure_dock" = true ]; then
        create_plank_autostart "$user_home"
        create_plank_theme "$user_home" "$theme_mode"
    else
        echo "Skipping Plank dock configuration."
    fi

    create_config_file "$user_home" "$theme_mode" "$accent_color"
    apply_theme_settings "$desktop_env" "$user_home" "$real_user" "$theme_mode" "$accent_color"

    if [ "$install_sounds" = true ]; then
        echo "Installing sound effects..."
        source "$PWD/scripts/sound_effects.sh"
        install_sound_effects "$user_home" "complete"
    else
        echo "Skipping sound effects installation."
    fi

    echo ""
    echo "Installation complete."
    echo "Please log out and log back in for all changes to apply fully." 

    chown -R "$real_user:$real_user" "$user_home/.themes" "$user_home/.icons" "$user_home/.config" "$user_home/Pictures/Wallpapers"

    start_plank "$real_user"
}

main "$@"
