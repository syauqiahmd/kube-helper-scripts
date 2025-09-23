#!/bin/bash

# This script installs the kube-helper-scripts to a directory in the user's PATH.

# --- Color Definitions ---
C_RESET='\033[0m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BOLD='\033[1m'

# Scripts to install
SCRIPTS=("klog" "kenv" "kdesc")

# --- Installation Logic ---

echo -e "${C_BOLD}Starting installation of Kubernetes Helper Scripts...${C_RESET}"

# Determine the installation directory
# 1. Prefer ~/.local/bin if it's in the PATH
# 2. Fallback to /usr/local/bin
INSTALL_DIR=""
if [[ ":$PATH:" == ":$HOME/.local/bin:" ]]; then
    INSTALL_DIR="$HOME/.local/bin"
elif [[ ":$PATH:" == ":$HOME/bin:" ]]; then
    INSTALL_DIR="$HOME/bin"
else
    INSTALL_DIR="/usr/local/bin"
fi

echo -e "The scripts will be installed to: ${C_YELLOW}${INSTALL_DIR}${C_RESET}"

# Create the directory if it doesn't exist (for user-local directories)
if [[ "$INSTALL_DIR" == "$HOME/.local/bin" || "$INSTALL_DIR" == "$HOME/bin" ]]; then
    mkdir -p "$INSTALL_DIR"
fi

# Check for write permissions. If we don't have them, prepend 'sudo' to the copy command.
SUDO_CMD=""
if [ ! -w "$INSTALL_DIR" ]; then
    echo -e "${C_YELLOW}Write access to ${INSTALL_DIR} is required. You may be prompted for your password.${C_RESET}"
    SUDO_CMD="sudo"
fi

# Loop through the scripts and install them
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        echo "- Installing '${script}'..."
        # Make the script executable
        chmod +x "$script"
        # Copy the script to the installation directory
        ${SUDO_CMD} cp "$script" "${INSTALL_DIR}/"
    else
        echo "- ${C_YELLOW}Warning: Script '${script}' not found. Skipping.${C_RESET}"
    fi
done

# --- Post-installation message ---
echo -e "\n${C_GREEN}Installation complete!${C_RESET}"

echo -e "The following scripts have been installed in ${C_YELLOW}${INSTALL_DIR}${C_RESET}:"
for script in "${SCRIPTS[@]}"; do
    echo "  - ${script}"
done

echo -e "\nPlease ensure that ${C_YELLOW}${INSTALL_DIR}${C_RESET} is in your shell's PATH."
echo "You may need to restart your terminal session or source your shell profile (e.g., 'source ~/.bashrc') for the commands to be available."
