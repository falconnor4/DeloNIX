# DeloNIX

My personal NixOS configuration, built with Flakes, Hyprland, and a focus on development and security.

## Features

-   **Core**: NixOS Unstable, Arch-like kernel (`linuxPackages_latest`), Secure Boot (Lanzaboote).
-   **Desktop**: Hyprland with Waybar, Dunst, Hyprlock, and Hypridle.
-   **Theming**: System-wide styling with Stylix (Catppuccin Mocha).
-   **Development**:
    -   **Neovim**: Full "Power User" setup (LSP, CMP, Telescope, Treesitter) via Nixvim.
    -   **Tools**: Tmux, Kando, Devenv, Gemini CLI.
    -   **Cloud**: Google Drive integration via Rclone.
-   **Security**: Metasploit, Shodan, Nix-Alien.

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

### 3. Fix Package Hashes
Some custom packages (like `fztea`) use placeholder hashes.
-   Try to build the config.
-   If it fails with a hash mismatch, copy the *actual* hash provided by Nix.
-   Update the `sha256` or `vendorHash` in `home/default.nix`.

### 4. Installation
Apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#default
```

## Keybindings (Hyprland)
-   `Super + Q`: Terminal (Kitty)
-   `Super + E`: File Manager (Dolphin)
-   `Super + R`: App Launcher (Wofi)
-   `Super + L`: Lock Screen
-   `Super + S`: Scratchpad
