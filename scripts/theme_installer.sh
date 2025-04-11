#!/bin/bash
# theme_installer.sh - Handles GTK theme installation

# Function to install WhiteSur GTK theme
install_gtk_theme() {
    local user_home="$1"
    local theme_mode="$2"
    local accent_color="$3"
    
    echo "🎨 Installing WhiteSur GTK theme..."
    cd /tmp
    rm -rf WhiteSur-gtk-theme 2>/dev/null || true
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git || error_exit "Failed to clone WhiteSur GTK theme"
    cd WhiteSur-gtk-theme
    
    # Build installation options
    INSTALL_OPTS="-t all --dest \"$user_home/.themes\""
    
    if [ "$theme_mode" = "dark" ]; then
        INSTALL_OPTS="$INSTALL_OPTS --dark"
    fi
    
    if [ "$accent_color" != "blue" ]; then
        INSTALL_OPTS="$INSTALL_OPTS --color $accent_color"
    fi
    
    # Use options for non-interactive installation
    eval "./install.sh $INSTALL_OPTS" || error_exit "Failed to install WhiteSur GTK theme"
    
    # Install tweaks for specific applications if available
    if [ -f "./tweaks.sh" ]; then
        echo "🔧 Installing application-specific tweaks..."
        ./tweaks.sh -f || true
    fi
    
    return 0
}

# Function to install WhiteSur icon theme
install_icon_theme() {
    local user_home="$1"
    
    echo "🖌️ Installing WhiteSur icons..."
    cd /tmp
    rm -rf WhiteSur-icon-theme 2>/dev/null || true
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git || error_exit "Failed to clone WhiteSur icon theme"
    cd WhiteSur-icon-theme
    ./install.sh --dest "$user_home/.icons" || error_exit "Failed to install WhiteSur icon theme"
    
    return 0
}

# Function to install cursor theme
install_cursor_theme() {
    local user_home="$1"
    
    echo "🖱️ Installing macOS-style cursor theme..."
    cd /tmp
    rm -rf macOS-Cursors 2>/dev/null || true
    git clone https://github.com/ful1e5/apple_cursor.git macOS-Cursors || error_exit "Failed to clone macOS cursor theme"
    cd macOS-Cursors
    
    # Check if prebuilt cursors are available in the dist directory
    if [ -d "./dist" ]; then
        mkdir -p "$user_home/.icons/macOS-Cursors"
        cp -r ./dist/* "$user_home/.icons/macOS-Cursors/" || error_exit "Failed to copy cursor theme"
    else
        warning_msg "Prebuilt cursors not found, skipping cursor theme installation"
    fi
    
    return 0
}

# Main function to install all theme components
install_theme_components() {
    local user_home="$1"
    local theme_mode="$2"
    local accent_color="$3"
    local installation_type="$4"
    
    install_gtk_theme "$user_home" "$theme_mode" "$accent_color"
    install_icon_theme "$user_home"
    
    if [ "$installation_type" = "complete" ]; then
        install_cursor_theme "$user_home"
    fi
    
    return 0
}
