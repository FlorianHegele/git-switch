# git-switch

A simple and efficient tool to easily manage multiple Git accounts per project.

## Description

`git-switch` allows you to quickly switch between different Git accounts (username, email, GPG key) based on your projects. Ideal for developers who work with multiple Git accounts (personal, professional, open-source, etc.) and want to avoid configuration errors.

## Features

- Management of multiple Git profiles (name, email, GPG key)
- Per-project configuration
- Easy installation and uninstallation

## Installation

After cloning this repository, simply run:

```bash
chmod +x ./install.sh
sudo ./install.sh
```

## Usage Examples

```bash
# Add a new account
git-switch -a personal

# List all available accounts
git-switch -l

# Use a specific account for the current project
git-switch -u professional

# Display help
git-switch -h
```

## Configuration

Accounts are stored in `~/.config/git-switch/account/*.conf`

### Checking the active configuration

To check the active Git configuration in a project:

```bash
git config user.name
git config user.email
git config user.signingkey
```

## Uninstallation

To uninstall git-switch from the system:

```bash
chmod +x ./uninstall.sh
sudo ./uninstall.sh
```
