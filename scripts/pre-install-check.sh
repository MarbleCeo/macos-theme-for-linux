#!/bin/bash
# pre-install-check.sh - Validates system requirements before installation

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

echo "Performing pre-installation checks..."
echo ""

# Check if running as sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}✗ Error: This script must be run with sudo${NC}"
    ((ERRORS++))
fi

# Check package manager
if ! command -v apt &> /dev/null && ! command -v dnf &> /dev/null && \
   ! command -v pacman &> /dev/null && ! command -v zypper &> /dev/null; then
    echo -e "${RED}✗ Error: Unsupported package manager (apt, dnf, pacman, zypper required)${NC}"
    ((ERRORS++))
else
    echo -e "${GREEN}✓ Package manager found${NC}"
fi

# Check internet connectivity
if ! ping -c 1 8.8.8.8 &> /dev/null; then
    echo -e "${YELLOW}⚠ Warning: Internet connectivity may be required for downloads${NC}"
    ((WARNINGS++))
else
    echo -e "${GREEN}✓ Internet connectivity verified${NC}"
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}⚠ Warning: git is recommended (will install with packages)${NC}"
    ((WARNINGS++))
else
    echo -e "${GREEN}✓ git found${NC}"
fi

# Check disk space (need at least 2GB free)
available_space=$(df / | awk 'NR==2 {print $4}')
if [ "$available_space" -lt 2097152 ]; then
    echo -e "${RED}✗ Error: At least 2GB free disk space required${NC}"
    ((ERRORS++))
else
    echo -e "${GREEN}✓ Sufficient disk space available${NC}"
fi

# Check desktop environment
if [ -n "${XDG_CURRENT_DESKTOP:-}" ] || [ -n "${XDG_SESSION_DESKTOP:-}" ]; then
    echo -e "${GREEN}✓ Desktop environment detected: ${XDG_CURRENT_DESKTOP:-${XDG_SESSION_DESKTOP}}${NC}"
else
    echo -e "${YELLOW}⚠ Warning: Could not detect desktop environment (will still attempt to install)${NC}"
    ((WARNINGS++))
fi

# Check if display server is available
if [ -z "${DISPLAY:-}" ]; then
    echo -e "${YELLOW}⚠ Warning: DISPLAY variable not set (are you in a graphical environment?)${NC}"
    ((WARNINGS++))
else
    echo -e "${GREEN}✓ Display server available: $DISPLAY${NC}"
fi

echo ""
echo "═══════════════════════════════════════"
echo "Pre-installation Check Results:"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"
echo "═══════════════════════════════════════"
echo ""

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}Installation cannot proceed. Please fix the errors above.${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}Installation can proceed, but please note the warnings above.${NC}"
    read -p "Continue with installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}All checks passed. Ready for installation.${NC}"
fi
