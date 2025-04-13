#!/bin/bash

# Colors for messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Checking administrator rights
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as administrator (sudo).${NC}"
    echo -e "Please try again with: ${YELLOW}sudo $0${NC}"
    exit 1
fi

echo -e "${BLUE}=== Uninstalling git-switch ===${NC}"

# 1. Removing the main script
echo -e "${YELLOW}Removing the git-switch command...${NC}"
if [ -f /usr/local/bin/git-switch ]; then
    rm -f /usr/local/bin/git-switch
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ The git-switch command has been successfully removed${NC}"
    else
        echo -e "${RED}✗ Failed to remove the git-switch command${NC}"
    fi
else
    echo -e "${YELLOW}! The git-switch command was not installed in /usr/local/bin/${NC}"
fi

# 2. Removing auto-completion
echo -e "${YELLOW}Removing auto-completion...${NC}"

# Distribution detection to find the right auto-completion directory
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

# Removing the completion file
if [ -f "${COMPLETION_DIR}/git-switch" ]; then
    rm -f "${COMPLETION_DIR}/git-switch"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Auto-completion has been successfully removed from ${COMPLETION_DIR}${NC}"
    else
        echo -e "${RED}✗ Failed to remove auto-completion${NC}"
    fi
else
    echo -e "${YELLOW}! The auto-completion file was not installed in ${COMPLETION_DIR}${NC}"
fi

# 3. Asking to remove configuration files
echo -e "${YELLOW}Do you also want to remove the configuration files? (y/N)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${YELLOW}Removing configuration files...${NC}"
    
    # Asking for which user to remove configuration files
    echo -e "${YELLOW}For which user do you want to remove the configuration files?${NC}"
    echo -e "${YELLOW}1. Current user ($(whoami))${NC}"
    echo -e "${YELLOW}2. Another user${NC}"
    echo -e "${YELLOW}3. All users${NC}"
    read -r user_option
    
    case $user_option in
        1)
            CONFIG_DIR="${HOME}/.config/git-switch"
            if [ -d "$CONFIG_DIR" ]; then
                rm -rf "$CONFIG_DIR"
                echo -e "${GREEN}✓ Configuration files have been removed for user $(whoami)${NC}"
            else
                echo -e "${YELLOW}! No configuration files found for user $(whoami)${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}Enter the username:${NC}"
            read -r username
            USER_HOME=$(eval echo ~$username)
            if [ -d "$USER_HOME" ]; then
                CONFIG_DIR="${USER_HOME}/.config/git-switch"
                if [ -d "$CONFIG_DIR" ]; then
                    rm -rf "$CONFIG_DIR"
                    echo -e "${GREEN}✓ Configuration files have been removed for user $username${NC}"
                else
                    echo -e "${YELLOW}! No configuration files found for user $username${NC}"
                fi
            else
                echo -e "${RED}✗ User $username does not exist or their home directory is not accessible${NC}"
            fi
            ;;
        3)
            echo -e "${YELLOW}Removing configuration files for all users...${NC}"
            for user_home in /home/*; do
                if [ -d "$user_home" ]; then
                    username=$(basename "$user_home")
                    CONFIG_DIR="${user_home}/.config/git-switch"
                    if [ -d "$CONFIG_DIR" ]; then
                        rm -rf "$CONFIG_DIR"
                        echo -e "${GREEN}✓ Configuration files have been removed for user $username${NC}"
                    fi
                fi
            done
            
            # Don't forget the root user directory
            ROOT_CONFIG_DIR="/root/.config/git-switch"
            if [ -d "$ROOT_CONFIG_DIR" ]; then
                rm -rf "$ROOT_CONFIG_DIR"
                echo -e "${GREEN}✓ Configuration files have been removed for user root${NC}"
            fi
            ;;
        *)
            echo -e "${YELLOW}Unrecognized option. Configuration files have not been removed.${NC}"
            ;;
    esac
else
    echo -e "${YELLOW}Configuration files have been kept.${NC}"
fi

echo -e "${BLUE}=== Uninstallation complete ===${NC}"
echo -e "${GREEN}git-switch has been uninstalled from the system.${NC}"

exit 0

