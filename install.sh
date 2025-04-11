#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

echo "🍎 Installing macOS Theme for Linux..."

# Function to display error messages and exit
error_exit() {
    echo "❌ ERROR: $1"
    exit 1
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    error_exit "Please run with sudo"
fi

# Detect distribution and package manager
echo "🔍 Detecting Linux distribution..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    DISTRO_LIKE=$ID_LIKE
    echo "📌 Detected distribution: $DISTRO"
else
    error_exit "Could not detect Linux distribution"
fi

# Determine package manager and install command
echo "🔧 Configuring package manager..."
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    UPDATE_CMD="apt update -y"
    INSTALL_CMD="apt install -y"
    PACKAGES="plank git wget unzip sassc libglib2.0-dev-bin curl"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    UPDATE_CMD="dnf check-update || true"
    INSTALL_CMD="dnf install -y"
    PACKAGES="plank git wget unzip sassc glib2-devel curl"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    UPDATE_CMD="pacman -Sy"
    INSTALL_CMD="pacman -S --noconfirm"
    PACKAGES="plank git wget unzip sassc glib2 curl"
elif command -v zypper &> /dev/null; then
    PKG_MANAGER="zypper"
    UPDATE_CMD="zypper refresh"
    INSTALL_CMD="zypper install -y"
    PACKAGES="plank git wget unzip sassc glib2-devel curl"
else
    error_exit "Unsupported package manager. Please install dependencies manually."
fi

# Update system
echo "📦 Updating package list..."
eval $UPDATE_CMD || error_exit "Failed to update package list"

# Install required packages
echo "📦 Installing required packages..."
eval "$INSTALL_CMD $PACKAGES" || error_exit "Failed to install required packages"

# Create required directories
echo "📁 Creating required directories..."
USER_HOME=$(eval echo ~$SUDO_USER)
mkdir -p $USER_HOME/.themes
mkdir -p $USER_HOME/.icons
mkdir -p $USER_HOME/.config/autostart
mkdir -p $USER_HOME/Pictures/Wallpapers

# Detect desktop environment
echo "🖥️ Detecting desktop environment..."
if [ -n "$XDG_CURRENT_DESKTOP" ]; then
    DESKTOP_ENV=$XDG_CURRENT_DESKTOP
elif [ -n "$XDG_SESSION_DESKTOP" ]; then
    DESKTOP_ENV=$XDG_SESSION_DESKTOP
elif [ -n "$DESKTOP_SESSION" ]; then
    DESKTOP_ENV=$DESKTOP_SESSION
else
    # Try to detect based on running processes
    if pgrep -x "gnome-shell" > /dev/null; then
        DESKTOP_ENV="GNOME"
    elif pgrep -x "plasmashell" > /dev/null; then
        DESKTOP_ENV="KDE"
    elif pgrep -x "xfce4-session" > /dev/null; then
        DESKTOP_ENV="XFCE"
    elif pgrep -x "cinnamon" > /dev/null; then
        DESKTOP_ENV="Cinnamon"
    elif pgrep -x "mate-session" > /dev/null; then
        DESKTOP_ENV="MATE"
    else
        DESKTOP_ENV="Unknown"
    fi
fi
echo "📌 Detected desktop environment: $DESKTOP_ENV"

# Download macOS-like wallpapers
echo "🖼️ Downloading macOS wallpapers..."
WALLPAPERS_DIR="$USER_HOME/Pictures/Wallpapers/macOS"
mkdir -p "$WALLPAPERS_DIR"

# Array of macOS wallpaper URLs
WALLPAPER_URLS=(
    "https://512pixels.net/downloads/macos-wallpapers/10-15-Day.jpg"
    "https://512pixels.net/downloads/macos-wallpapers/11-0-Light.jpg"
    "https://512pixels.net/downloads/macos-wallpapers/12-Light.jpg"
    "https://512pixels.net/downloads/macos-wallpapers/13-Light.jpg"
)

for url in "${WALLPAPER_URLS[@]}"; do
    filename=$(basename "$url")
    if ! curl -s -o "$WALLPAPERS_DIR/$filename" "$url"; then
        echo "⚠️ Warning: Failed to download wallpaper: $url"
    fi
done

# Set a macOS wallpaper according to the desktop environment
if [ -f "$WALLPAPERS_DIR/13-Light.jpg" ]; then
    WALLPAPER_PATH="$WALLPAPERS_DIR/13-Light.jpg"
    echo "🖼️ Setting macOS wallpaper..."
    
    case $DESKTOP_ENV in
        *XFCE*)
            # Set XFCE wallpaper
            sudo -u $SUDO_USER xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WALLPAPER_PATH" 2>/dev/null || true
            ;;
        *GNOME*|*Ubuntu*)
            # Set GNOME wallpaper
            sudo -u $SUDO_USER gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH" 2>/dev/null || true
            sudo -u $SUDO_USER gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH" 2>/dev/null || true
            ;;
        *KDE*|*Plasma*)
            # For KDE/Plasma
            if command -v plasma-apply-wallpaperimage &> /dev/null; then
                sudo -u $SUDO_USER plasma-apply-wallpaperimage "$WALLPAPER_PATH" 2>/dev/null || true
            fi
            ;;
        *Cinnamon*)
            # For Cinnamon
            sudo -u $SUDO_USER gsettings set org.cinnamon.desktop.background picture-uri "file://$WALLPAPER_PATH" 2>/dev/null || true
            ;;
        *MATE*)
            # For MATE
            sudo -u $SUDO_USER gsettings set org.mate.background picture-filename "$WALLPAPER_PATH" 2>/dev/null || true
            ;;
    esac
fi

# Clone and install WhiteSur theme
echo "🎨 Installing WhiteSur GTK theme..."
cd /tmp
rm -rf WhiteSur-gtk-theme 2>/dev/null || true
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git || error_exit "Failed to clone WhiteSur GTK theme"
cd WhiteSur-gtk-theme

# Use options for non-interactive installation
./install.sh -t all --dest "$USER_HOME/.themes" -n 2>/dev/null || ./install.sh -t all || error_exit "Failed to install WhiteSur GTK theme"

# Install WhiteSur icons
echo "🎨 Installing WhiteSur icons..."
cd /tmp
rm -rf WhiteSur-icon-theme 2>/dev/null || true
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git || error_exit "Failed to clone WhiteSur icon theme"
cd WhiteSur-icon-theme
./install.sh --dest "$USER_HOME/.icons" 2>/dev/null || ./install.sh || error_exit "Failed to install WhiteSur icon theme"

# Configure Plank
echo "🚀 Configuring Plank dock..."
cat > "$USER_HOME/.config/autostart/plank.desktop" << 'END'
[Desktop Entry]
Type=Application
Name=Plank
Comment=Plank dock
Exec=plank
Icon=plank
Terminal=false
Categories=Utility;
END

# Apply theme settings based on desktop environment
echo "🎯 Applying theme settings..."
case $DESKTOP_ENV in
    *XFCE*)
        # Apply theme for XFCE
        sudo -u $SUDO_USER xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Light" 2>/dev/null || true
        sudo -u $SUDO_USER xfconf-query -c xfwm4 -p /general/theme -s "WhiteSur-Light" 2>/dev/null || true
        sudo -u $SUDO_USER xfconf-query -c xsettings -p /Net/IconThemeName -s "WhiteSur-light" 2>/dev/null || true
        ;;
    *GNOME*|*Ubuntu*)
        # Apply theme for GNOME
        sudo -u $SUDO_USER gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
        sudo -u $SUDO_USER gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-light" 2>/dev/null || true
        ;;
    *KDE*|*Plasma*)
        # For KDE/Plasma (using lookandfeeltool if available)
        if command -v lookandfeeltool &> /dev/null; then
            sudo -u $SUDO_USER lookandfeeltool -a org.kde.breeze.desktop 2>/dev/null || true
        fi
        echo "ℹ️ For KDE Plasma: You may need to manually apply the theme in System Settings"
        ;;
    *Cinnamon*)
        # For Cinnamon
        sudo -u $SUDO_USER gsettings set org.cinnamon.desktop.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
        sudo -u $SUDO_USER gsettings set org.cinnamon.desktop.interface icon-theme "WhiteSur-light" 2>/dev/null || true
        ;;
    *MATE*)
        # For MATE
        sudo -u $SUDO_USER gsettings set org.mate.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
        sudo -u $SUDO_USER gsettings set org.mate.interface icon-theme "WhiteSur-light" 2>/dev/null || true
        ;;
    *)
        echo "⚠️ Unknown desktop environment. You may need to apply themes manually."
        ;;
esac

# Configure Plank theme (macOS-like)
PLANK_CONFIG_DIR="$USER_HOME/.config/plank"
PLANK_THEME_DIR="$PLANK_CONFIG_DIR/themes"
mkdir -p "$PLANK_THEME_DIR/macOS"

# Create a macOS-like theme for Plank
cat > "$PLANK_THEME_DIR/macOS/dock.theme" << 'END'
[PlankTheme]
TopRoundness=4
BottomRoundness=0
LineWidth=1
OuterStrokeColor=22;;22;;22;;255
FillStartColor=240;;240;;240;;220
FillEndColor=240;;240;;240;;220
InnerStrokeColor=240;;240;;240;;220

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

# Start Plank
echo "🚀 Starting Plank dock..."
sudo -u $SUDO_USER DISPLAY=:0 plank &

# Clean up temporary files
echo "🧹 Cleaning up temporary files..."
rm -rf /tmp/WhiteSur-gtk-theme /tmp/WhiteSur-icon-theme 2>/dev/null || true

# Change ownership of the created directories to the user
chown -R $SUDO_USER:$SUDO_USER "$USER_HOME/.themes" "$USER_HOME/.icons" "$USER_HOME/.config" "$USER_HOME/Pictures/Wallpapers" 2>/dev/null || true

echo "✅ Installation complete!"
echo "🔄 Please log out and log back in for all changes to take effect."
