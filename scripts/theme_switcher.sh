#!/bin/bash
# theme_switcher.sh - Allows switching between light and dark themes

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to display error messages and exit
error_exit() {
    echo -e "${RED}❌ ERROR: $1${NC}"
    exit 1
}

# Function to display success messages
success_msg() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to switch theme based on desktop environment
switch_theme() {
    local user_home="$1"
    local desktop_env="$2"
    local theme_mode="$3"  # "light" or "dark"
    local accent_color="$4"
    
    # Determine theme name based on mode and accent color
    if [ "$theme_mode" = "dark" ]; then
        if [ "$accent_color" = "blue" ] || [ -z "$accent_color" ]; then
            THEME_NAME="WhiteSur-Dark"
            ICON_THEME="WhiteSur-dark"
        else
            THEME_NAME="WhiteSur-Dark-$accent_color"
            ICON_THEME="WhiteSur-dark"
        fi
        WALLPAPER_SUFFIX="Dark.jpg"
    else
        if [ "$accent_color" = "blue" ] || [ -z "$accent_color" ]; then
            THEME_NAME="WhiteSur-Light"
            ICON_THEME="WhiteSur-light"
        else
            THEME_NAME="WhiteSur-Light-$accent_color"
            ICON_THEME="WhiteSur-light"
        fi
        WALLPAPER_SUFFIX="Light.jpg"
    fi
    
    echo -e "${BLUE}🔹 Switching to ${theme_mode} mode...${NC}"
    
    # Set theme based on desktop environment
    case "$desktop_env" in
        *XFCE*)
            # Apply theme for XFCE
            xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME_NAME" 2>/dev/null || true
            xfconf-query -c xfwm4 -p /general/theme -s "$THEME_NAME" 2>/dev/null || true
            xfconf-query -c xsettings -p /Net/IconThemeName -s "$ICON_THEME" 2>/dev/null || true
            
            # Set wallpaper
            WALLPAPER_PATH="$user_home/Pictures/Wallpapers/macOS/14-0-$WALLPAPER_SUFFIX"
            if [ -f "$WALLPAPER_PATH" ]; then
                xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WALLPAPER_PATH" 2>/dev/null || true
            fi
            ;;
        *GNOME*|*Ubuntu*)
            # Apply theme for GNOME
            gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME" 2>/dev/null || true
            gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null || true
            
            # Set wallpaper
            WALLPAPER_PATH="$user_home/Pictures/Wallpapers/macOS/14-0-$WALLPAPER_SUFFIX"
            if [ -f "$WALLPAPER_PATH" ]; then
                gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH" 2>/dev/null || true
                gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH" 2>/dev/null || true
            fi
            ;;
        *KDE*|*Plasma*)
            # For KDE/Plasma, we can try using lookandfeeltool but this might need more user intervention
            if command -v lookandfeeltool &> /dev/null; then
                lookandfeeltool -a org.kde.breeze.desktop 2>/dev/null || true
            fi
            
            # For KDE/Plasma wallpaper
            if command -v plasma-apply-wallpaperimage &> /dev/null; then
                WALLPAPER_PATH="$user_home/Pictures/Wallpapers/macOS/14-0-$WALLPAPER_SUFFIX"
                if [ -f "$WALLPAPER_PATH" ]; then
                    plasma-apply-wallpaperimage "$WALLPAPER_PATH" 2>/dev/null || true
                fi
            fi
            
            echo -e "${YELLOW}⚠️ For KDE Plasma: You may need to manually apply the theme in System Settings${NC}"
            ;;
        *Cinnamon*)
            # For Cinnamon
            gsettings set org.cinnamon.desktop.interface gtk-theme "$THEME_NAME" 2>/dev/null || true
            gsettings set org.cinnamon.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null || true
            
            # Set wallpaper
            WALLPAPER_PATH="$user_home/Pictures/Wallpapers/macOS/14-0-$WALLPAPER_SUFFIX"
            if [ -f "$WALLPAPER_PATH" ]; then
                gsettings set org.cinnamon.desktop.background picture-uri "file://$WALLPAPER_PATH" 2>/dev/null || true
            fi
            ;;
        *MATE*)
            # For MATE
            gsettings set org.mate.interface gtk-theme "$THEME_NAME" 2>/dev/null || true
            gsettings set org.mate.interface icon-theme "$ICON_THEME" 2>/dev/null || true
            
            # Set wallpaper
            WALLPAPER_PATH="$user_home/Pictures/Wallpapers/macOS/14-0-$WALLPAPER_SUFFIX"
            if [ -f "$WALLPAPER_PATH" ]; then
                gsettings set org.mate.background picture-filename "$WALLPAPER_PATH" 2>/dev/null || true
            fi
            ;;
        *)
            echo -e "${YELLOW}⚠️ Unknown desktop environment. You may need to apply themes manually.${NC}"
            ;;
    esac
    
    # Update Plank dock theme if it exists
    update_plank_theme "$user_home" "$theme_mode"
    
    # Update config file
    update_config_file "$user_home" "$theme_mode" "$accent_color"
    
    success_msg "Theme switched to ${theme_mode} mode!"
    return 0
}

# Function to update the Plank dock theme
update_plank_theme() {
    local user_home="$1"
    local theme_mode="$2"
    
    PLANK_THEME_DIR="$user_home/.config/plank/themes/macOS"
    
    # Skip if Plank theme directory doesn't exist
    if [ ! -d "$PLANK_THEME_DIR" ]; then
        return 0
    fi
    
    # Determine theme colors based on mode
    if [ "$theme_mode" = "dark" ]; then
        FILL_COLOR="50;;50;;50"
        STROKE_COLOR="30;;30;;30"
    else
        FILL_COLOR="240;;240;;240"
        STROKE_COLOR="220;;220;;220"
    fi
    
    # Create a macOS-like theme for Plank
    cat > "$PLANK_THEME_DIR/dock.theme" << END
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
    
    # Restart Plank if it's running
    if pgrep -x "plank" > /dev/null; then
        killall plank 2>/dev/null
        sleep 1
        DISPLAY=:0 plank &
    fi
    
    return 0
}

# Function to update the config file
update_config_file() {
    local user_home="$1"
    local theme_mode="$2"
    local accent_color="$3"
    
    CONFIG_FILE="$user_home/.config/macos-theme-config.conf"
    
    # Skip if config file doesn't exist
    if [ ! -f "$CONFIG_FILE" ]; then
        return 0
    fi
    
    # Update theme mode in config file
    sed -i "s/THEME_MODE=.*/THEME_MODE=\"$theme_mode\"/" "$CONFIG_FILE"
    
    # Update accent color if provided
    if [ -n "$accent_color" ]; then
        sed -i "s/ACCENT_COLOR=.*/ACCENT_COLOR=\"$accent_color\"/" "$CONFIG_FILE"
    fi
    
    return 0
}

# Main function
main() {
    # Parse command line arguments
    THEME_MODE=""
    ACCENT_COLOR=""
    
    for arg in "$@"; do
        case $arg in
            --light)
                THEME_MODE="light"
                shift
                ;;
            --dark)
                THEME_MODE="dark"
                shift
                ;;
            --accent=*)
                ACCENT_COLOR="${arg#*=}"
                shift
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo ""
                echo "Options:"
                echo "  --light          Switch to light mode"
                echo "  --dark           Switch to dark mode"
                echo "  --accent=COLOR   Set accent color (blue, purple, pink, red, orange, yellow, green)"
                echo "  --help           Display this help message"
                exit 0
                ;;
            *)
                # Unknown option
                ;;
        esac
    done
    
    # Check if theme mode is provided
    if [ -z "$THEME_MODE" ]; then
        error_exit "Please specify --light or --dark mode"
    fi
    
    # Get user home directory
    if [ -n "$SUDO_USER" ]; then
        USER_HOME=$(eval echo ~$SUDO_USER)
    else
        USER_HOME=$HOME
    fi
    
    # Load desktop environment from config file if possible
    CONFIG_FILE="$USER_HOME/.config/macos-theme-config.conf"
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        DESKTOP_ENV_CONFIG="$DESKTOP_ENV"
    fi
    
    # Detect desktop environment if not found in config
    if [ -z "$DESKTOP_ENV_CONFIG" ]; then
        if [ -n "$XDG_CURRENT_DESKTOP" ]; then
            DESKTOP_ENV="$XDG_CURRENT_DESKTOP"
        elif [ -n "$XDG_SESSION_DESKTOP" ]; then
            DESKTOP_ENV="$XDG_SESSION_DESKTOP"
        elif [ -n "$DESKTOP_SESSION" ]; then
            DESKTOP_ENV="$DESKTOP_SESSION"
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
    else
        DESKTOP_ENV="$DESKTOP_ENV_CONFIG"
    fi
    
    # Get accent color from config if not provided and config exists
    if [ -z "$ACCENT_COLOR" ] && [ -f "$CONFIG_FILE" ]; then
        ACCENT_COLOR_CONFIG="$ACCENT_COLOR"
        if [ -n "$ACCENT_COLOR_CONFIG" ]; then
            ACCENT_COLOR="$ACCENT_COLOR_CONFIG"
        fi
    fi
    
    # Switch theme
    switch_theme "$USER_HOME" "$DESKTOP_ENV" "$THEME_MODE" "$ACCENT_COLOR"
    
    return 0
}

# Run main function
main "$@"
