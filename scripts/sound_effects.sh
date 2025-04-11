#!/bin/bash
# sound_effects.sh - Installs and configures macOS-like sound effects

# Function to install macOS sound effects
install_sound_effects() {
    local user_home="$1"
    local installation_type="$2"
    
    # Only install sounds if complete installation is selected
    if [ "$installation_type" != "complete" ]; then
        return 0
    fi
    
    echo "🔊 Installing macOS sound effects..."
    
    # Create sound directory structure
    SOUNDS_DIR="$user_home/.local/share/sounds/macos"
    mkdir -p "$SOUNDS_DIR/stereo"
    
    # Download macOS sound effects
    SOUND_URLS=(
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Basso.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Blow.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Bottle.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Frog.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Funk.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Glass.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Hero.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Morse.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Ping.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Pop.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Purr.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Sosumi.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Submarine.aiff"
        "https://github.com/petrstepanov/macos-sounds/raw/main/sounds/Tink.aiff"
    )
    
    for url in "${SOUND_URLS[@]}"; do
        filename=$(basename "$url")
        output_wav="${filename%.aiff}.wav"
        
        # Download the sound file
        if ! curl -s -o "/tmp/$filename" "$url"; then
            echo "⚠️ Warning: Failed to download sound: $url"
            continue
        fi
        
        # Convert AIFF to WAV if ffmpeg is available
        if command -v ffmpeg &> /dev/null; then
            ffmpeg -i "/tmp/$filename" -y "$SOUNDS_DIR/stereo/$output_wav" -loglevel error
            if [ $? -ne 0 ]; then
                echo "⚠️ Warning: Failed to convert $filename to WAV"
                # Try to copy the original file as fallback
                cp "/tmp/$filename" "$SOUNDS_DIR/stereo/"
            fi
        else
            # Just copy the original file if ffmpeg is not available
            cp "/tmp/$filename" "$SOUNDS_DIR/stereo/"
        fi
    done
    
    # Create sound theme file
    cat > "$SOUNDS_DIR/index.theme" << 'END'
[Sound Theme]
Name=macOS
Comment=macOS sound effects theme
Directories=stereo

[stereo]
OutputProfile=stereo
END
    
    # Create sound theme configuration
    mkdir -p "$user_home/.config/macos-theme-suite"
    cat > "$user_home/.config/macos-theme-suite/sound-mappings.conf" << 'END'
# macOS Sound Mappings
login=Submarine.wav
logout=Blow.wav
startup=Submarine.wav
shutdown=Blow.wav
error=Basso.wav
trash=Glass.wav
alert=Ping.wav
notification=Tink.wav
plugged-in=Bottle.wav
plugged-out=Pop.wav
completion=Purr.wav
dialog-information=Frog.wav
dialog-warning=Sosumi.wav
dialog-error=Basso.wav
END
    
    # Configure system sounds based on desktop environment
    configure_system_sounds "$user_home" "$DESKTOP_ENV"
    
    return 0
}

# Function to configure system sounds based on desktop environment
configure_system_sounds() {
    local user_home="$1"
    local desktop_env="$2"
    
    case "$desktop_env" in
        *GNOME*|*Ubuntu*)
            # For GNOME
            sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound theme-name "macos" 2>/dev/null || true
            sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound input-feedback-sounds true 2>/dev/null || true
            ;;
        *XFCE*)
            # For XFCE
            xfconf_dir="$user_home/.config/xfce4/xfconf/xfce-perchannel-xml"
            mkdir -p "$xfconf_dir"
            
            # Create or update xfce4-settings configuration for sounds
            if [ -f "$xfconf_dir/xfce4-settings-manager.xml" ]; then
                sed -i 's/<property name="EnableInputFeedbackSounds" type="bool" value="false"\/>/<property name="EnableInputFeedbackSounds" type="bool" value="true"\/>/g' "$xfconf_dir/xfce4-settings-manager.xml"
                sed -i 's/<property name="EnableEventSounds" type="bool" value="false"\/>/<property name="EnableEventSounds" type="bool" value="true"\/>/g' "$xfconf_dir/xfce4-settings-manager.xml"
            else
                cat > "$xfconf_dir/xfce4-settings-manager.xml" << 'END'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-settings-manager" version="1.0">
  <property name="last" type="empty">
    <property name="window-width" type="int" value="700"/>
    <property name="window-height" type="int" value="500"/>
    <property name="EnableInputFeedbackSounds" type="bool" value="true"/>
    <property name="EnableEventSounds" type="bool" value="true"/>
    <property name="SoundThemeName" type="string" value="macos"/>
  </property>
</channel>
END
            fi
            ;;
        *KDE*|*Plasma*)
            # For KDE Plasma
            kde_config="$user_home/.config/plasmarc"
            if [ -f "$kde_config" ]; then
                # Check if [Sounds] section exists
                if grep -q "\[Sounds\]" "$kde_config"; then
                    # Update existing section
                    sed -i '/\[Sounds\]/,/\[/ s/Theme=.*/Theme=macos/' "$kde_config"
                else
                    # Add new section
                    echo -e "\n[Sounds]\nTheme=macos" >> "$kde_config"
                fi
            else
                # Create new config file
                cat > "$kde_config" << 'END'
[Sounds]
Theme=macos
END
            fi
            ;;
        *Cinnamon*)
            # For Cinnamon
            sudo -u "$SUDO_USER" gsettings set org.cinnamon.desktop.sound theme-name "macos" 2>/dev/null || true
            sudo -u "$SUDO_USER" gsettings set org.cinnamon.desktop.sound input-feedback-sounds true 2>/dev/null || true
            ;;
        *MATE*)
            # For MATE
            sudo -u "$SUDO_USER" gsettings set org.mate.sound theme-name "macos" 2>/dev/null || true
            sudo -u "$SUDO_USER" gsettings set org.mate.sound input-feedback-sounds true 2>/dev/null || true
            ;;
    esac
    
    return 0
}

# Function to enable or disable sound effects
toggle_sound_effects() {
    local user_home="$1"
    local desktop_env="$2"
    local enabled="$3"  # true or false
    
    if [ "$enabled" = "true" ]; then
        echo "🔊 Enabling macOS sound effects..."
    else
        echo "🔇 Disabling macOS sound effects..."
    fi
    
    case "$desktop_env" in
        *GNOME*|*Ubuntu*)
            # For GNOME
            if [ "$enabled" = "true" ]; then
                sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound theme-name "macos" 2>/dev/null || true
                sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound input-feedback-sounds true 2>/dev/null || true
            else
                sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound theme-name "freedesktop" 2>/dev/null || true
                sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound input-feedback-sounds false 2>/dev/null || true
            fi
            ;;
        *XFCE*)
            # For XFCE
            xfconf_dir="$user_home/.config/xfce4/xfconf/xfce-perchannel-xml"
            if [ -f "$xfconf_dir/xfce4-settings-manager.xml" ]; then
                if [ "$enabled" = "true" ]; then
                    sed -i 's/<property name="EnableInputFeedbackSounds" type="bool" value="false"\/>/<property name="EnableInputFeedbackSounds" type="bool" value="true"\/>/g' "$xfconf_dir/xfce4-settings-manager.xml"
                    sed -i 's/<property name="EnableEventSounds" type="bool" value="false"\/>/<property name="EnableEventSounds" type="bool" value="true"\/>/g' "$xfconf_dir/xfce4-settings-manager.xml"
                    sed -i 's/<property name="SoundThemeName" type="string" value=".*"\/>/<property name="SoundThemeName" type="string" value="macos"\/>/g' "$xfconf_dir/xfce4-settings-manager.xml"
                else
                    sed -i 's/<property name="EnableInputFeedbackSounds" type="bool" value="true"\/>/<property name="EnableInputFeedbackSounds" type="bool" value="false"\/>/g' "$xfconf_dir/xfce4-settings-manager.xml"
                    sed -i 's/<property name="EnableEventSounds" type="bool" value="true"\/>/<property name="EnableEventSounds" type="bool" value="false"\/>/g' "$xfconf_dir/xfce4-settings-manager.xml"
                    sed -i 's/<property name="SoundThemeName" type="string" value="macos"\/>/<property name="SoundThemeName" type="string" value="freedesktop"\/>/g' "$xfconf_dir/xfce4-settings-manager.xml"
                fi
            fi
            ;;
    esac
    
    return 0
}
