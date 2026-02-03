# DeloNIX

My personal NixOS configuration, built with Flakes, Hyprland, and a focus on development and security.

## Features

-   **Core**: NixOS Unstable, Arch-like kernel (`linuxPackages_latest`), Secure Boot (Lanzaboote).
-   **Desktop**: Hyprland with Waybar, Dunst, Hyprlock, and Hypridle.
-   **Theming**: System-wide styling with Stylix (Catppuccin Mocha), enhanced Waybar with custom styling.
-   **Development**:
    -   **Neovim**: Full "Power User" setup (LSP, CMP, Telescope, Treesitter) via Nixvim.
    -   **Tools**: Tmux, Kando, Devenv, Gemini CLI, GitHub CLI, LazyGit.
    -   **Cloud**: Google Drive integration via Rclone.
    -   **Comma**: Command-not-found integration with automatic package running.
-   **Security**: Metasploit, Shodan, Nix-Alien.
-   **CLI Tools**: Modern replacements (eza, bat, ripgrep, fd, fzf, zoxide) and monitoring (btop, htop, ncdu).
-   **Media**: MPV, IMV, Discord, Spotify.

## Enhanced Features

### Comma
The `comma` package provides a convenient way to run programs without installing them permanently. Simply prefix any command with a comma:
```bash
, cowsay "Hello NixOS!"
```

### Visual Enhancements (Rice)
-   **Animations**: Smooth window animations with custom bezier curves
-   **Blur**: Enabled blur effects with rounded corners (10px)
-   **Waybar**: Enhanced status bar with:
    -   System monitoring (CPU, memory, temperature)
    -   Network status with signal strength
    -   PulseAudio volume control
    -   Battery status with icons
    -   Custom Catppuccin Mocha styling
-   **Kitty Terminal**: Configured with transparency (95% opacity) and custom padding
-   **Screenshots**: Integrated with grim and slurp for easy screenshot capture

## Setup Instructions

### 1. Hardware Configuration
This repo contains a placeholder hardware config. You **must** generate one for your specific machine:

```bash
# Run this on the target machine
nixos-generate-config --show-hardware-config > hosts/default/hardware-configuration.nix
```

### 2. Google Drive Setup (Rclone)
To enable the automatic Google Drive mount:

1.  Run configuration wizard:
    ```bash
    rclone config
    ```
2.  Create a new remote named **`gdrive`** (Select "Google Drive").
3.  Follow the authentication prompts.
4.  The systemd service `rclone-gdrive-mount` will automatically mount it to `~/GoogleDrive` on login.

### 3. Local AI (Opencode & Llama)
This config includes **Opencode** and a local **Llama 2.5** model configuration.

-   **Llama Server**:
    -   To enable the AI backend, run: `llama-start`
    -   To stop it and free RAM, run: `llama-stop`
    -   The server runs at `http://127.0.0.1:8080`.
-   **Opencode**:
    -   Run `opencode` in your terminal.
    -   The configuration is auto-generated at `~/.config/opencode/config.json`.

### 4. Fix Package Hashes
Some custom packages (like `fztea`) use placeholder hashes.
-   Try to build the config.
-   If it fails with a hash mismatch, copy the *actual* hash provided by Nix.
-   Update the `sha256` or `vendorHash` in `home/default.nix`.

### 5. Installation
Apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#default
```

## Keybindings (Hyprland)

### Basic
-   `Super + Q`: Terminal (Kitty)
-   `Super + C`: Close active window
-   `Super + M`: Exit Hyprland
-   `Super + E`: File Manager (Dolphin)
-   `Super + R`: App Launcher (Wofi)
-   `Super + V`: Toggle floating mode
-   `Super + F`: Toggle fullscreen
-   `Super + Shift + L`: Lock Screen
-   `Super + S`: Toggle Scratchpad
-   `Super + Shift + S`: Move window to Scratchpad

### Window Navigation
-   `Super + Arrow Keys`: Move focus between windows

### Workspaces
-   `Super + [0-9]`: Switch to workspace 1-10
-   `Super + Shift + [0-9]`: Move active window to workspace 1-10

### Screenshots
-   `Print`: Screenshot selection to clipboard
-   `Super + Print`: Screenshot full screen to clipboard
-   `Shift + Print`: Screenshot selection to file in ~/Pictures

### Mouse
-   `Super + Left Click`: Move window
-   `Super + Right Click`: Resize window
