#!/bin/bash
# dock_configurator.sh - Configures the Plank dock with macOS-like appearance and functionality

# Function to configure the Plank dock
configure_plank_dock() {
    local user_home="$1"
    local theme_mode="$2"
    
    echo "🚀 Configuring Plank dock..."
    
    # Set up Plank autostart
    cat > "$user_home/.config/autostart/plank.desktop" << 'END'
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

    # Configure Plank theme (macOS-like)
    PLANK_CONFIG_DIR="$user_home/.config/plank"
    PLANK_THEME_DIR="$PLANK_CONFIG_DIR/themes"
    mkdir -p "$PLANK_THEME_DIR/macOS"
    
    # Determine theme colors based on mode
    if [ "$theme_mode" = "dark" ]; then
        FILL_COLOR="50;;50;;50"
        STROKE_COLOR="30;;30;;30"
    else
        FILL_COLOR="240;;240;;240"
        STROKE_COLOR="220;;220;;220"
    fi
    
    # Create a macOS-like theme for Plank
    cat > "$PLANK_THEME_DIR/macOS/dock.theme" << END
[PlankTheme]
TopRoundness=4
BottomRoundness=0
LineWidth=1
OuterStrokeColor=22;;22;;22;;255
FillStartColor=${FILL_COLOR};;220
FillEndColor=${FILL_COLOR};;220
InnerStrokeColor=${STROKE_COLOR};;220

[PlankDockTheme]
HorizPadding=4
TopPadding=2
BottomPadding=2
ItemPadding=3
IndicatorSize=5
IconShadowSize=1
UrgentBounceHeight=1.6666666666666667
LaunchBounceHeight=0.625
FadeOpacity=1
ClickTime=300
UrgentBounceTime=600
LaunchBounceTime=600
ActiveTime=300
SlideTime=300
FadeTime=250
HideTime=250
GlowSize=30
GlowTime=10000
GlowPulseTime=2000
UrgentHueShift=150
ItemMoveTime=450
CascadeHide=true
END
    
    # Configure default Plank settings
    mkdir -p "$PLANK_CONFIG_DIR/dock1"
    cat > "$PLANK_CONFIG_DIR/dock1/settings" << 'END'
[PlankDockPreferences]
#Whether to show only windows of the current workspace.
CurrentWorkspaceOnly=false
#The size of dock icons (in pixels).
IconSize=48
#If 0, the dock won't hide. If 1, the dock intelligently hides. If 2, the dock auto-hides. If 3, the dock dodges active maximized windows. If 4, the dock dodges every window.
HideMode=1
#Time (in ms) to wait before unhiding the dock.
UnhideDelay=0
#The monitor number for the dock. Use -1 to keep on the primary monitor.
Monitor=-1
#List of *.dockitem files on this dock. DO NOT MODIFY
DockItems=plank.dockitem;;trash.dockitem
#The position for the dock on the monitor. If 0, left. If 1, right. If 2, top. If 3, bottom.
Position=3
#The dock's position offset from center (in percent).
Offset=0
#The name of the dock's theme to use.
Theme=macOS
#The alignment for the dock on the monitor's edge. If 0, panel-mode. If 1, left-aligned. If 2, right-aligned. If 3, centered.
Alignment=3
#Whether to prevent drag'n'drop actions and lock items on the dock.
LockItems=false
#Whether to use pressure-based revealing of the dock if the support is available.
PressureReveal=false
#Whether to show only pinned applications.
PinnedOnly=false
#Whether to automatically pin an application if it seems useful to do so.
AutoPinning=true
#Whether to show the item for the dock itself.
ShowDockItem=false
#Whether the dock will zoom when hovered.
ZoomEnabled=true
#The dock's icon-zoom (in percent).
ZoomPercent=150
END
    
    # Create basic dock items (similar to macOS)
    if [ ! -f "$PLANK_CONFIG_DIR/dock1/plank.dockitem" ]; then
        echo "[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/plank.desktop" > "$PLANK_CONFIG_DIR/dock1/plank.dockitem"
    fi
    
    if [ ! -f "$PLANK_CONFIG_DIR/dock1/trash.dockitem" ]; then
        echo "[PlankDockItemPreferences]
Launcher=trash://" > "$PLANK_CONFIG_DIR/dock1/trash.dockitem"
    fi
    
    # Add common applications to dock if they exist
    add_app_to_dock "$PLANK_CONFIG_DIR/dock1" "org.gnome.Nautilus.desktop" "file-manager" "/usr/share/applications/org.gnome.Nautilus.desktop"
    add_app_to_dock "$PLANK_CONFIG_DIR/dock1" "firefox.desktop" "web-browser" "/usr/share/applications/firefox.desktop"
    add_app_to_dock "$PLANK_CONFIG_DIR/dock1" "org.gnome.Terminal.desktop" "terminal" "/usr/share/applications/org.gnome.Terminal.desktop"
    
    return 0
}

# Helper function to add application to dock
add_app_to_dock() {
    local dock_dir="$1"
    local app_id="$2"
    local app_type="$3"
    local app_path="$4"
    
    # Check if the application exists
    if [ -f "$app_path" ]; then
        if [ ! -f "$dock_dir/$app_id" ]; then
            echo "[PlankDockItemPreferences]
Launcher=file://$app_path" > "$dock_dir/$app_id"
            
            # Update DockItems in settings
            DOCK_ITEMS=$(grep "DockItems=" "$dock_dir/settings" | cut -d'=' -f2)
            NEW_DOCK_ITEMS="${DOCK_ITEMS};;$app_id"
            sed -i "s/DockItems=$DOCK_ITEMS/DockItems=$NEW_DOCK_ITEMS/" "$dock_dir/settings"
        fi
    else
        # Try alternative applications based on type
        case "$app_type" in
            "file-manager")
                alt_apps=("thunar.desktop" "nemo.desktop" "caja.desktop" "dolphin.desktop")
                ;;
            "web-browser")
                alt_apps=("google-chrome.desktop" "chromium-browser.desktop" "epiphany.desktop" "falkon.desktop")
                ;;
            "terminal")
                alt_apps=("xfce4-terminal.desktop" "konsole.desktop" "gnome-terminal.desktop" "mate-terminal.desktop")
                ;;
            *)
                alt_apps=()
                ;;
        esac
        
        # Try each alternative
        for alt_app in "${alt_apps[@]}"; do
            if [ -f "/usr/share/applications/$alt_app" ]; then
                if [ ! -f "$dock_dir/$alt_app" ]; then
                    echo "[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/$alt_app" > "$dock_dir/$alt_app"
                    
                    # Update DockItems in settings
                    DOCK_ITEMS=$(grep "DockItems=" "$dock_dir/settings" | cut -d'=' -f2)
                    NEW_DOCK_ITEMS="${DOCK_ITEMS};;$alt_app"
                    sed -i "s/DockItems=$DOCK_ITEMS/DockItems=$NEW_DOCK_ITEMS/" "$dock_dir/settings"
                    break
                fi
            fi
        done
    fi
}

# Start Plank with the new configuration
start_plank() {
    local user="$1"
    
    echo "🚀 Starting Plank dock..."
    sudo -u "$user" DISPLAY=:0 plank &
    
    return 0
}
