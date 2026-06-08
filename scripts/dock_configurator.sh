#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# dock_configurator.sh - Configures the Plank dock with macOS-like appearance and functionality

configure_plank_dock() {
    local user_home="$1"
    local theme_mode="$2"

    echo "Configuring Plank dock..."

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

    local plank_config_dir="$user_home/.config/plank"
    local plank_theme_dir="$plank_config_dir/themes"
    mkdir -p "$plank_theme_dir/macOS"

    if [ "$theme_mode" = "dark" ]; then
        local fill_color="30;;30;;30"
        local stroke_color="20;;20;;20"
        local outer_stroke="15;;15;;15;;255"
    else
        local fill_color="245;;245;;245"
        local stroke_color="225;;225;;225"
        local outer_stroke="180;;180;;180;;200"
    fi

    cat > "$plank_theme_dir/macOS/dock.theme" <<END
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

    mkdir -p "$plank_config_dir/dock1"
    cat > "$plank_config_dir/dock1/settings" <<'END'
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

    if [ ! -f "$plank_config_dir/dock1/plank.dockitem" ]; then
        echo "[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/plank.desktop" > "$plank_config_dir/dock1/plank.dockitem"
    fi

    if [ ! -f "$plank_config_dir/dock1/trash.dockitem" ]; then
        echo "[PlankDockItemPreferences]
Launcher=trash://" > "$plank_config_dir/dock1/trash.dockitem"
    fi

    add_app_to_dock "$plank_config_dir/dock1" "org.gnome.Nautilus.desktop" "file-manager" "/usr/share/applications/org.gnome.Nautilus.desktop"
    add_app_to_dock "$plank_config_dir/dock1" "firefox.desktop" "web-browser" "/usr/share/applications/firefox.desktop"
    add_app_to_dock "$plank_config_dir/dock1" "org.gnome.Terminal.desktop" "terminal" "/usr/share/applications/org.gnome.Terminal.desktop"
}

add_app_to_dock() {
    local dock_dir="$1"
    local app_id="$2"
    local app_type="$3"
    local app_path="$4"

    if [ -f "$app_path" ]; then
        if [ ! -f "$dock_dir/$app_id" ]; then
            echo "[PlankDockItemPreferences]
Launcher=file://$app_path" > "$dock_dir/$app_id"
            local dock_items
            dock_items=$(grep "DockItems=" "$dock_dir/settings" | cut -d'=' -f2)
            local new_dock_items="${dock_items};;$app_id"
            sed -i "s|DockItems=$dock_items|DockItems=$new_dock_items|" "$dock_dir/settings"
        fi
    else
        case "$app_type" in
            file-manager)
                alt_apps=("thunar.desktop" "nemo.desktop" "caja.desktop" "dolphin.desktop")
                ;;
            web-browser)
                alt_apps=("google-chrome.desktop" "chromium-browser.desktop" "epiphany.desktop" "falkon.desktop")
                ;;
            terminal)
                alt_apps=("xfce4-terminal.desktop" "konsole.desktop" "gnome-terminal.desktop" "mate-terminal.desktop")
                ;;
            *)
                alt_apps=()
                ;;
        esac

        for alt_app in "${alt_apps[@]}"; do
            if [ -f "/usr/share/applications/$alt_app" ] && [ ! -f "$dock_dir/$alt_app" ]; then
                echo "[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/$alt_app" > "$dock_dir/$alt_app"
                local dock_items
                dock_items=$(grep "DockItems=" "$dock_dir/settings" | cut -d'=' -f2)
                local new_dock_items="${dock_items};;$alt_app"
                sed -i "s|DockItems=$dock_items|DockItems=$new_dock_items|" "$dock_dir/settings"
                break
            fi
        done
    fi
}

start_plank() {
    local user="$1"
    if command -v plank &> /dev/null; then
        echo "Starting Plank dock..."
        sudo -u "$user" DISPLAY=:0 plank &> /dev/null || true
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if [ -n "${SUDO_USER:-}" ]; then
        USER_HOME="${1:-$(eval echo ~$SUDO_USER)}"
    else
        USER_HOME="${1:-$HOME}"
    fi
    THEME_MODE="${2:-light}"
    configure_plank_dock "$USER_HOME" "$THEME_MODE"
    if [ -n "${SUDO_USER:-}" ]; then
        start_plank "$SUDO_USER"
    else
        start_plank "$(id -un)"
    fi
fi
