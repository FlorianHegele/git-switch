#!/bin/bash

# Installation script for git-switch
# To be executed after cloning the repository

# Colors for messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Checking administrator rights
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as administrator (sudo).${NC}"
    echo -e "Please try again with: ${YELLOW}sudo $0${NC}"
    exit 1
fi

echo -e "${GREEN}=== Installing git-switch ===${NC}"

# Checking that necessary files exist
if [ ! -f "git-switch" ]; then
    echo -e "${RED}Error: The 'git-switch' file is not found.${NC}"
    echo -e "Make sure you run this script from the cloned project directory."
    exit 1
fi

if [ ! -f "git-switch-completion" ]; then
    echo -e "${RED}Error: The 'git-switch-completion' file is not found.${NC}"
    echo -e "Make sure you run this script from the cloned project directory."
    exit 1
fi

# 1. Installing the main script
echo -e "${YELLOW}Installing the git-switch command...${NC}"
install -v -m 755 git-switch /usr/local/bin/git-switch

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ The git-switch command has been successfully installed in /usr/local/bin/${NC}"
else
    echo -e "${RED}✗ Failed to install the git-switch command${NC}"
    exit 1
fi

# 2. Installing auto-completion
echo -e "${YELLOW}Installing auto-completion...${NC}"

# Distribution detection
if [ -f /etc/debian_version ]; then
    # Debian/Ubuntu
    COMPLETION_DIR="/etc/bash_completion.d"
elif [ -f /etc/arch-release ]; then
    # Arch Linux
    COMPLETION_DIR="/usr/share/bash-completion/completions"
elif [ -f /etc/redhat-release ]; then
    # CentOS/RHEL/Fedora
    COMPLETION_DIR="/etc/bash_completion.d"
else
    # Fallback
    COMPLETION_DIR="/etc/bash_completion.d"
    echo -e "${YELLOW}Unrecognized distribution, using default directory: ${COMPLETION_DIR}${NC}"
fi

# Creating the directory if it doesn't exist
mkdir -p "$COMPLETION_DIR"

# Installing the completion file
if [ -d "$COMPLETION_DIR" ]; then
    if [ "$COMPLETION_DIR" = "/usr/share/bash-completion/completions" ]; then
        # For Arch Linux, rename the file with the command name
        install -v -m 644 git-switch-completion "$COMPLETION_DIR/git-switch"
    else
        # For other distributions
        install -v -m 644 git-switch-completion "$COMPLETION_DIR/git-switch"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Auto-completion has been successfully installed in ${COMPLETION_DIR}${NC}"
    else
        echo -e "${RED}✗ Failed to install auto-completion${NC}"
    fi
else
    echo -e "${RED}✗ The auto-completion directory ${COMPLETION_DIR} does not exist and could not be created${NC}"
fi

# 3. Creating the configuration directory
echo -e "${YELLOW}Creating the configuration directory...${NC}"
mkdir -p "${HOME}/.config/git-switch/account"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ The configuration directory has been created: ${HOME}/.config/git-switch/account/${NC}"
else
    echo -e "${RED}✗ Failed to create the configuration directory${NC}"
fi

echo -e "${GREEN}=== Installation complete ===${NC}"
echo -e "You can now use the ${YELLOW}git-switch${NC} command"

exit 0

