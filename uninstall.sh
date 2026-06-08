#!/bin/bash
# uninstall.sh - Removes macOS Theme Suite for Linux

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    cat <<'EOF'
Usage: ./uninstall.sh [OPTIONS]

Options:
  --force        Remove without confirmation
  --preserve     Keep wallpapers and config
  --help         Show this help message
EOF
}

validate_user() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: This script requires sudo privileges.${NC}"
        exit 1
    fi
}

confirm_uninstall() {
    echo -e "${YELLOW}This will remove:${NC}"
    echo "  - WhiteSur GTK theme from ~/.themes/"
    echo "  - WhiteSur icons from ~/.icons/"
    echo "  - macOS cursors from ~/.icons/"
    echo "  - Plank dock configuration"
    echo "  - macOS wallpapers (unless --preserve)"
    echo "  - macOS sound effects (unless --preserve)"
    echo ""
    read -p "Continue uninstall? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}

uninstall_themes() {
    local user_home="$1"
    
    echo "Removing themes and icons..."
    rm -rf "$user_home/.themes/WhiteSur"* 2>/dev/null || true
    rm -rf "$user_home/.icons/WhiteSur"* 2>/dev/null || true
    rm -rf "$user_home/.icons/Capitaine"* 2>/dev/null || true
}

uninstall_dock() {
    local user_home="$1"
    
    echo "Removing Plank configuration..."
    rm -rf "$user_home/.config/plank" 2>/dev/null || true
    rm -f "$user_home/.config/autostart/plank.desktop" 2>/dev/null || true
}

uninstall_sounds() {
    local user_home="$1"
    
    echo "Removing sound effects..."
    rm -rf "$user_home/.local/share/sounds/macos" 2>/dev/null || true
    rm -rf "$user_home/.config/macos-theme-suite" 2>/dev/null || true
}

uninstall_wallpapers() {
    local user_home="$1"
    
    echo "Removing wallpapers..."
    rm -rf "$user_home/Pictures/Wallpapers/macOS" 2>/dev/null || true
}

uninstall_config() {
    local user_home="$1"
    
    echo "Removing configuration..."
    rm -f "$user_home/.config/macos-theme-config.conf" 2>/dev/null || true
}

main() {
    local force=false
    local preserve=false

    while [ "$#" -gt 0 ]; do
        case "$1" in
            --force)
                force=true
                shift
                ;;
            --preserve)
                preserve=true
                shift
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                echo "Error: Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    validate_user

    if [ "$force" = false ]; then
        confirm_uninstall
    fi

    local user_home
    user_home="$(eval echo ~$SUDO_USER)"

    uninstall_themes "$user_home"
    uninstall_dock "$user_home"
    uninstall_sounds "$user_home"
    uninstall_config "$user_home"

    if [ "$preserve" = false ]; then
        uninstall_wallpapers "$user_home"
    fi

    chown -R "$SUDO_USER:$SUDO_USER" "$user_home/.themes" "$user_home/.icons" \
        "$user_home/.config" "$user_home/.local" "$user_home/Pictures" 2>/dev/null || true

    echo ""
    echo -e "${GREEN}Uninstallation complete.${NC}"
    echo "Please log out and log back in for changes to take effect."
}

main "$@"
