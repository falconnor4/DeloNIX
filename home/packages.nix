{ config, pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    tmux
    devenv

    # Custom fztea package
    (buildGoModule rec {
      pname = "fztea";
      version = "0.6.4";

      src = fetchFromGitHub {
        owner = "jon4hz";
        repo = "fztea";
        rev = "v${version}";
        sha256 = "0pnjay790kg4hv3ygqk4q6afd77zkml7kf30lbhbzxdq867zjdj2";
      };

      vendorHash = "sha256-eDQHX7sXsHT8Hhg/U+NrD+VYZ/DRfTz5KeAOi4vD+/k=";
    })

    # Fonts
    pkgs.nerd-fonts.jetbrains-mono

    # Cloud Storage
    rclone

    # Gaming
    inputs.lsfg-vk-flake.packages.${pkgs.system}.default
    
    # GUI Applications
    kitty                   # Terminal emulator
    kdePackages.dolphin     # File manager
    grim                    # Screenshot tool
    slurp                   # Screen selection tool
    wl-clipboard            # Wayland clipboard utilities
    pavucontrol             # PulseAudio volume control
    brightnessctl           # Brightness control
    playerctl               # Media player control
    networkmanagerapplet    # Network manager applet
    blueman                 # Bluetooth Manager
        
    # CLI Tools
    neofetch    # System info
    cmatrix     # Matrix effect in terminal
    lolcat      # Colorful output
    figlet      # ASCII art text
    
    # Media and Productivity
    mpv         # Video player
    imv         # Image viewer
    discord     # Communication
    spotify     # Music
    
    # Development
    gh          # GitHub CLI
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.antigravity.packages.${pkgs.system}.default
    inputs.opencode.packages.${pkgs.system}.default
    
    # Google Drive
    kdePackages.kio-gdrive  # Native Dolphin Support
    (pkgs.writeShellScriptBin "setup-gdrive" ''
      echo "Setting up Google Drive..."
      if ${pkgs.rclone}/bin/rclone listremotes | grep -q "^gdrive:"; then
        echo "Remote 'gdrive' already exists."
      else
        echo "Launching browser for authentication..."
        ${pkgs.rclone}/bin/rclone config create gdrive drive 
      fi
      
      echo "Enabling mount service..."
      mkdir -p ~/GoogleDrive
      systemctl --user daemon-reload
      systemctl --user restart rclone-gdrive-mount
      
      echo "Done! Drive should be mounted at ~/GoogleDrive"
    '')

    # Power Menu Script
    (pkgs.writeShellScriptBin "power-menu" ''
      entries=" Rebuild\n Lock\n Suspend\n Reboot\n Shutdown\n Logout"
      selected=$(echo -e "$entries" | wofi --width 250 --height 270 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

      case $selected in
        rebuild)
          kitty --title "NixOS Rebuild" --hold -e sudo nixos-rebuild switch --flake /home/falconnor4/github/nixos
          ;;
        lock)
          pidof hyprlock || hyprlock
          ;;
        suspend)
          systemctl suspend
          ;;
        reboot)
          systemctl reboot
          ;;
        shutdown)
          systemctl poweroff
          ;;
        logout)
          hyprctl dispatch exit
          ;;
      esac
    (pkgs.writeShellScriptBin "start-local-ai" ''
      MODEL_DIR="$HOME/.cache/opencode/models"
      MODEL_FILE="$MODEL_DIR/huihui.gguf"
      MODEL_URL="https://huggingface.co/mradermacher/Huihui-LFM2.5-1.2B-Thinking-abliterated-i1-GGUF/resolve/main/Huihui-LFM2.5-1.2B-Thinking-abliterated.i1-Q4_K_M.gguf"

      mkdir -p "$MODEL_DIR"

      if [ ! -f "$MODEL_FILE" ]; then
        echo "Downloading model..."
        ${pkgs.wget}/bin/wget -O "$MODEL_FILE" "$MODEL_URL"
      fi

      echo "Starting local AI server..."
      ${pkgs.llama-cpp}/bin/llama-server -m "$MODEL_FILE" --port 8080 --host 127.0.0.1 -c 4096 -ngl 99
    '')
  ];
}
