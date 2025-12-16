{ config, pkgs, inputs, ... }:

{
  # Packages
  home.packages = with pkgs; [
    tmux
    kando
    devenv
    gemini-cli

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

      vendorHash = "sha256-eDQHX7sXsHT8Hhg/U+NrD+VYZ/DRfTz5KeAOi4vD+/k="; # Replace with actual hash after first build failure
    })

    # Fonts
    # Fonts
    pkgs.nerd-fonts.jetbrains-mono

    # Cloud Storage
    rclone

    # Gaming
    inputs.lsfg-vk-flake.packages.${pkgs.system}.default
    
    # Additional GUI applications for ricing
    kitty # Terminal emulator (better than default)
    kdePackages.dolphin # File manager
    wofi # Application launcher
    grim # Screenshot tool
    slurp # Screen selection tool
    wl-clipboard # Wayland clipboard utilities
    pavucontrol # PulseAudio volume control
    brightnessctl # Brightness control
    networkmanagerapplet # Network manager applet
    wlogout # Logout menu
        
    # Additional CLI tools
    neofetch # System info
    cmatrix # Matrix effect in terminal
    lolcat # Colorful output
    figlet # ASCII art text
    
    # Media and productivity
    mpv # Video player
    imv # Image viewer
    discord # Communication
    spotify # Music
    
    # Development extras
    gh # GitHub CLI
    # lazygit # TUI for git - Moved to programs.lazygit module below
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.antigravity.packages.${pkgs.system}.default

    # Google Drive Helpers
    kdePackages.kio-gdrive # Native Dolphin Support
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
  ];

  # Hyprland User Config
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Basic Hyprland configuration
      "$mod" = "SUPER";
      monitor = [
        ",preferred,auto,1"
      ];
      
      # General settings for animations and behavior
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };
      
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
      };
      
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      bind = [
        "$mod, Q, exec, kitty"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating,"
        "$mod, R, exec, wofi --show drun"
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle
        "$mod, F, fullscreen,"

        # Scratchpad
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        
        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        
        # Lock screen (moved here to avoid conflict)
        "$mod SHIFT, L, exec, hyprlock"
        
        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Screenshot bindings
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, Print, exec, grim - | wl-copy"
        "SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      exec-once = [
        "waybar"
        "dunst"
        "hypridle"

        "nm-applet --indicator"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user start hyprpolkitagent"
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1" 
      ];
    };
  };

  # Ricing & Tools
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 8;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "tray" "custom/power" ];
        
        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };
        
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
          sort-by-number = true;
        };
        
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };
        
        clock = {
          format = " {:%H:%M   %d/%m/%Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        cpu = {
          format = " {usage}%";
          tooltip = false;
          interval = 2;
        };
        
        memory = {
          format = " {}%";
          interval = 2;
        };
        
        temperature = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" ];
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
        
        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " Connected";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        
        tray = {
          spacing = 10;
        };
      };
    };
    style = ''
      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 13px;
        min-height: 0;
      }
      
      window#waybar {
        background: transparent;
      }
      
      #workspaces button {
        padding: 0 8px;
        background: transparent;
        color: @text;
        border-radius: 8px;
        margin: 4px;
      }
      
      #workspaces button.active {
        background: @surface0;
        color: @lavender;
      }
      
      #workspaces button.urgent {
        background: @red;
        color: @crust;
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray,
      #window {
        padding: 4px 12px;
        margin: 4px 2px;
        background: @surface0;
        border-radius: 8px;
      }
      
      #battery.charging {
        background: @green;
        color: @crust;
      }
      
      #battery.warning:not(.charging) {
        background: @yellow;
        color: @crust;
      }
      
      #battery.critical:not(.charging) {
        background: @red;
        color: @crust;
      }
      
      #temperature.critical {
        background: @red;
        color: @crust;
      }
      
      #custom-power {
        background: @red;
        color: @crust;
        padding: 4px 12px;
        margin: 4px 2px;
        border-radius: 8px;
      }

    '';
  };

  services.dunst.enable = true;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(24, 24, 37)";
          outer_color = "rgb(24, 24, 37)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };



  # Google Drive Mount
  systemd.user.services.rclone-gdrive-mount = {
    Unit = {
      Description = "Mount Google Drive";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/GoogleDrive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount gdrive: %h/GoogleDrive --vfs-cache-mode writes";
      ExecStop = "/run/current-system/sw/bin/fusermount -u %h/GoogleDrive";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };



  # Nixvim
  # Nixvim
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    
    plugins = {
      lualine.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      which-key.enable = true;
      gitsigns.enable = true;
      nvim-autopairs.enable = true;
      comment.enable = true;

      # Visuals
      indent-blankline.enable = true;
      todo-comments.enable = true;

      # LSP
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          gopls.enable = true;
          pyright.enable = true;
        };
      };

      # Autocompletion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
    };
  };

  # Kitty terminal configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      background_opacity = "0.95";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 10;
    };
  };

  # Stylix is configured system-wide, but can be overridden here if needed

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  programs.lazygit.enable = true;
}
