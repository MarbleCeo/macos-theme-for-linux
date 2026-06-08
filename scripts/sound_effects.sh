#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# sound_effects.sh - Installs and configures macOS-like sound effects

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

install_sound_effects() {
    local user_home="$1"
    local installation_type="$2"

    if [ "$installation_type" != "complete" ]; then
        return 0
    fi

    echo "Installing macOS sound effects..."
    local sounds_dir="$user_home/.local/share/sounds/macos"
    mkdir -p "$sounds_dir/stereo"

    local sound_urls=(
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

    for url in "${sound_urls[@]}"; do
        local filename
        filename=$(basename "$url")
        local output_wav="${filename%.aiff}.wav"

        if ! curl -s -o "/tmp/$filename" "$url"; then
            echo "⚠️ Warning: Failed to download sound: $url"
            continue
        fi

        if command -v ffmpeg &> /dev/null; then
            if ! ffmpeg -i "/tmp/$filename" -y "$sounds_dir/stereo/$output_wav" -loglevel error; then
                echo "⚠️ Warning: Failed to convert $filename to WAV"
                cp "/tmp/$filename" "$sounds_dir/stereo/"
            fi
        else
            cp "/tmp/$filename" "$sounds_dir/stereo/"
        fi
    done

    cat > "$sounds_dir/index.theme" <<'END'
[Sound Theme]
Name=macOS
Comment=macOS sound effects theme
Directories=stereo

[stereo]
OutputProfile=stereo
END

    mkdir -p "$user_home/.config/macos-theme-suite"
    cat > "$user_home/.config/macos-theme-suite/sound-mappings.conf" <<'END'
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

    configure_system_sounds "$user_home" "${DESKTOP_ENV:-$(detect_desktop_env)}"
}

configure_system_sounds() {
    local user_home="$1"
    local desktop_env="$2"

    case "$desktop_env" in
        *GNOME*|*Ubuntu*)
            sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound theme-name "macos" 2>/dev/null || true
            sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound input-feedback-sounds true 2>/dev/null || true
            ;;
        *XFCE*)
            local xfconf_dir="$user_home/.config/xfce4/xfconf/xfce-perchannel-xml"
            mkdir -p "$xfconf_dir"
            if [ -f "$xfconf_dir/xfce4-settings-manager.xml" ]; then
                sed -i 's|<property name="EnableInputFeedbackSounds" type="bool" value="false"/>|<property name="EnableInputFeedbackSounds" type="bool" value="true"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
                sed -i 's|<property name="EnableEventSounds" type="bool" value="false"/>|<property name="EnableEventSounds" type="bool" value="true"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
                sed -i 's|<property name="SoundThemeName" type="string" value=".*"/>|<property name="SoundThemeName" type="string" value="macos"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
            else
                cat > "$xfconf_dir/xfce4-settings-manager.xml" <<'END'
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
            local kde_config="$user_home/.config/plasmarc"
            if [ -f "$kde_config" ]; then
                if grep -q "\[Sounds\]" "$kde_config"; then
                    sed -i '/\[Sounds\]/, /\[/ s|Theme=.*|Theme=macos|' "$kde_config"
                else
                    echo -e "\n[Sounds]\nTheme=macos" >> "$kde_config"
                fi
            else
                cat > "$kde_config" <<'END'
[Sounds]
Theme=macos
END
            fi
            ;;
        *Cinnamon*)
            sudo -u "$SUDO_USER" gsettings set org.cinnamon.desktop.sound theme-name "macos" 2>/dev/null || true
            sudo -u "$SUDO_USER" gsettings set org.cinnamon.desktop.sound input-feedback-sounds true 2>/dev/null || true
            ;;
        *MATE*)
            sudo -u "$SUDO_USER" gsettings set org.mate.sound theme-name "macos" 2>/dev/null || true
            sudo -u "$SUDO_USER" gsettings set org.mate.sound input-feedback-sounds true 2>/dev/null || true
            ;;
    esac
}

toggle_sound_effects() {
    local user_home="$1"
    local desktop_env="$2"
    local enabled="$3"

    if [ "$enabled" = "true" ]; then
        echo "Enabling macOS sound effects..."
    else
        echo "Disabling macOS sound effects..."
    fi

    case "$desktop_env" in
        *GNOME*|*Ubuntu*)
            if [ "$enabled" = "true" ]; then
                sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound theme-name "macos" 2>/dev/null || true
                sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound input-feedback-sounds true 2>/dev/null || true
            else
                sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound theme-name "freedesktop" 2>/dev/null || true
                sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.sound input-feedback-sounds false 2>/dev/null || true
            fi
            ;;
        *XFCE*)
            local xfconf_dir="$user_home/.config/xfce4/xfconf/xfce-perchannel-xml"
            if [ -f "$xfconf_dir/xfce4-settings-manager.xml" ]; then
                if [ "$enabled" = "true" ]; then
                    sed -i 's|<property name="EnableInputFeedbackSounds" type="bool" value="false"/>|<property name="EnableInputFeedbackSounds" type="bool" value="true"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
                    sed -i 's|<property name="EnableEventSounds" type="bool" value="false"/>|<property name="EnableEventSounds" type="bool" value="true"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
                    sed -i 's|<property name="SoundThemeName" type="string" value=".*"/>|<property name="SoundThemeName" type="string" value="macos"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
                else
                    sed -i 's|<property name="EnableInputFeedbackSounds" type="bool" value="true"/>|<property name="EnableInputFeedbackSounds" type="bool" value="false"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
                    sed -i 's|<property name="EnableEventSounds" type="bool" value="true"/>|<property name="EnableEventSounds" type="bool" value="false"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
                    sed -i 's|<property name="SoundThemeName" type="string" value="macos"/>|<property name="SoundThemeName" type="string" value="freedesktop"/>|g' "$xfconf_dir/xfce4-settings-manager.xml"
                fi
            fi
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if [ -n "${SUDO_USER:-}" ]; then
        USER_HOME="$(eval echo ~$SUDO_USER)"
    else
        USER_HOME="$HOME"
    fi
    DESKTOP_ENV="$(detect_desktop_env)"

    case "${1:-}" in
        install)
            install_sound_effects "$USER_HOME" "complete"
            ;;
        enable)
            toggle_sound_effects "$USER_HOME" "$DESKTOP_ENV" true
            ;;
        disable)
            toggle_sound_effects "$USER_HOME" "$DESKTOP_ENV" false
            ;;
        *)
            echo "Usage: $0 {install|enable|disable}"
            exit 1
            ;;
    esac
fi
