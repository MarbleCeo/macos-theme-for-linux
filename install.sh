#!/bin/bash
# macOS Theme for Linux - Enhanced Installation Script
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ ERROR: Please run with sudo"
    exit 1
fi

# Get real user
USER_HOME=$(eval echo ~$SUDO_USER)
REAL_USER=$SUDO_USER

echo "🍎 Installing macOS Theme Suite for Linux..."

# Detect package manager and install dependencies
if command -v apt &> /dev/null; then
    echo "📦 Using APT package manager"
    apt update -y
    apt install -y plank git wget unzip sassc libglib2.0-dev-bin curl
elif command -v dnf &> /dev/null; then
    echo "📦 Using DNF package manager"
    dnf check-update || true
    dnf install -y plank git wget unzip sassc glib2-devel curl
elif command -v pacman &> /dev/null; then
    echo "📦 Using Pacman package manager"
    pacman -Sy
    pacman -S --noconfirm plank git wget unzip sassc glib2 curl
elif command -v zypper &> /dev/null; then
    echo "📦 Using Zypper package manager"
    zypper refresh
    zypper install -y plank git wget unzip sassc glib2-devel curl
else
    echo "❌ ERROR: Unsupported package manager"
    exit 1
fi

# Create directories
mkdir -p "$USER_HOME/.themes" "$USER_HOME/.icons" "$USER_HOME/.config/autostart" "$USER_HOME/Pictures/Wallpapers/macOS"

# Detect desktop environment
if [ -n "$XDG_CURRENT_DESKTOP" ]; then
    DESKTOP_ENV=$XDG_CURRENT_DESKTOP
elif [ -n "$XDG_SESSION_DESKTOP" ]; then
    DESKTOP_ENV=$XDG_SESSION_DESKTOP
elif [ -n "$DESKTOP_SESSION" ]; then
    DESKTOP_ENV=$DESKTOP_SESSION
else
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
echo "🖥️ Detected desktop environment: $DESKTOP_ENV"

# Download wallpapers
echo "🖼️ Downloading macOS wallpapers..."
WALLPAPERS_DIR="$USER_HOME/Pictures/Wallpapers/macOS"
wget -q -O "$WALLPAPERS_DIR/sonoma-light.jpg" "https://512pixels.net/downloads/macos-wallpapers/14-0-Light.jpg" || echo "⚠️ Warning: Failed to download wallpaper"
wget -q -O "$WALLPAPERS_DIR/sonoma-dark.jpg" "https://512pixels.net/downloads/macos-wallpapers/14-0-Dark.jpg" || echo "⚠️ Warning: Failed to download wallpaper"

# Install WhiteSur GTK theme
echo "🎨 Installing WhiteSur GTK theme..."
cd /tmp
rm -rf WhiteSur-gtk-theme 2>/dev/null || true
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh -t all --dest "$USER_HOME/.themes"

# Install WhiteSur icons
echo "🎨 Installing WhiteSur icon theme..."
cd /tmp
rm -rf WhiteSur-icon-theme 2>/dev/null || true
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh --dest "$USER_HOME/.icons"

# Configure Plank dock
echo "🚀 Configuring Plank dock..."
mkdir -p "$USER_HOME/.config/plank/themes/macOS"
cat > "$USER_HOME/.config/autostart/plank.desktop" << 'END'
[Desktop Entry]
Type=Application
Name=Plank
Comment=macOS-style Dock
Exec=plank
Icon=plank
Terminal=false
Categories=Utility;
END

# Create macOS-like Plank theme
cat > "$USER_HOME/.config/plank/themes/macOS/dock.theme" << 'END'
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

# Configure Plank settings
mkdir -p "$USER_HOME/.config/plank/dock1"
cat > "$USER_HOME/.config/plank/dock1/settings" << 'END'
[PlankDockPreferences]
CurrentWorkspaceOnly=false
IconSize=48
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
ZoomPercent=150
END

# Create basic dock items
echo "[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/plank.desktop" > "$USER_HOME/.config/plank/dock1/plank.dockitem"

echo "[PlankDockItemPreferences]
Launcher=trash://" > "$USER_HOME/.config/plank/dock1/trash.dockitem"

# Apply theme based on desktop environment
echo "🎯 Applying theme settings..."
case $DESKTOP_ENV in
    *XFCE*)
        sudo -u $REAL_USER xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Light" 2>/dev/null || true
        sudo -u $REAL_USER xfconf-query -c xfwm4 -p /general/theme -s "WhiteSur-Light" 2>/dev/null || true
        sudo -u $REAL_USER xfconf-query -c xsettings -p /Net/IconThemeName -s "WhiteSur-light" 2>/dev/null || true
        ;;
    *GNOME*|*Ubuntu*)
        sudo -u $REAL_USER gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
        sudo -u $REAL_USER gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-light" 2>/dev/null || true
        ;;
    *KDE*|*Plasma*)
        echo "ℹ️ KDE detected: You may need to apply theme manually in System Settings"
        ;;
    *Cinnamon*)
        sudo -u $REAL_USER gsettings set org.cinnamon.desktop.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
        sudo -u $REAL_USER gsettings set org.cinnamon.desktop.interface icon-theme "WhiteSur-light" 2>/dev/null || true
        ;;
    *MATE*)
        sudo -u $REAL_USER gsettings set org.mate.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
        sudo -u $REAL_USER gsettings set org.mate.interface icon-theme "WhiteSur-light" 2>/dev/null || true
        ;;
    *)
        echo "⚠️ Unknown desktop environment. You may need to apply themes manually."
        ;;
esac

# Set correct permissions
chown -R $REAL_USER:$REAL_USER "$USER_HOME/.themes" "$USER_HOME/.icons" "$USER_HOME/.config" "$USER_HOME/Pictures/Wallpapers"

# Start Plank
echo "🚀 Starting Plank dock..."
sudo -u $REAL_USER DISPLAY=:0 plank &

echo "✅ Installation complete!"
echo "🔄 Please log out and log back in for all changes to take effect."
