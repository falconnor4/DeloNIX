{ config, pkgs, inputs, lib, ... }:

{
  # Hyprpanel - Modern panel for Hyprland with integrated features
  programs.hyprpanel = {
    enable = true;
    
    settings = {
      # Bar layout configuration
      layout = {
        "bar.layouts" = {
          "0" = {
            left = [ "dashboard" "workspaces" ];
            middle = [ "media" "clock" ];
            right = [ "network" "bluetooth" "battery" "volume" "systray" "notifications" ];
          };
        };
      };
      
      # Bar settings
      bar = {
        launcher.autoDetectIcon = false;
        launcher.icon = "󱄅";  # Nix logo (nf-md-nix)
        workspaces = {
          show_icons = true;
          show_numbered = true;
          numbered_active_indicator = "highlight";
        };
      };
      
      # Clock menu settings
      menus.clock = {
        time = {
          military = false;
          hideSeconds = true;
        };
        weather = {
          enabled = true;
          unit = "imperial";
        };
      };
      
      # Dashboard settings - Utility focused (no app shortcuts)
      menus.dashboard = {
        directories.enabled = false;
        stats.enable_gpu = false;
        powermenu.enabled = true;
        shortcuts.enabled = false;
      };
      
      # Power menu configuration
      menus.power = {
        lowBatteryNotification = true;
        lowBatteryThreshold = 20;
      };
      
      # Bluetooth module settings
      bar.bluetooth = {
        label = true;
      };
      
      # Theme settings - Sleek sharp look
      theme = {
        bar = {
          transparent = false;
          floating = false;
          
          # Button styling for clean appearance
          buttons = {
            enableBorders = false;
            radius = lib.mkForce "0px";
            padding_x = lib.mkForce "8px";
            padding_y = lib.mkForce "4px";
            spacing = lib.mkForce "0em";
          };
          
          # Solid bar - no margins
          margin_top = lib.mkForce "0px";
          margin_sides = lib.mkForce "0px";
          margin_bottom = lib.mkForce "0px";
          
          # Bar outer styling - sharp corners
          outer_spacing = lib.mkForce "0px";
          border_radius = lib.mkForce "0px";
        };
        
        font = {
          name = lib.mkForce "CaskaydiaCove NF";
          size = lib.mkForce "13px";
        };
        
        # Notification styling - sharp
        notification = {
          border_radius = lib.mkForce "0px";
        };
        
        # Menu styling - sharp
        menu = {
          border_radius = lib.mkForce "0px";
        };
        
        # OSD styling - sharp
        osd = {
          border_radius = lib.mkForce "0px";
        };
      };
      
      # Notifications
      notifications = {
        position = "top right";
        timeout = 5000;
        showActionsOnHover = true;
      };
      
      # Scalable features
      scalingPriority = "hyprland";
    };
  };
  
  # Dependencies for Hyprpanel functionality
  home.packages = with pkgs; [ 
    playerctl          # Media controls
    brightnessctl      # Brightness control
    pamixer            # Volume control
    blueman            # Bluetooth manager (for extended settings)
    pavucontrol        # Audio settings (for extended settings)
    networkmanagerapplet  # For extended network settings
    nerd-fonts.caskaydia-cove  # Font for icons
  ];

  # Wofi as app launcher (Super+R)
  programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 400;
      show = "drun";
      prompt = "Search...";
      allow_images = true;
      image_size = 32;
      term = "kitty";
      insensitive = true;
    };
    style = ''
      window {
        border-radius: 0px;
        background-color: rgba(30, 30, 46, 0.95);
        border: 1px solid rgba(137, 180, 250, 0.5);
      }
      
      #input {
        border-radius: 0px;
        padding: 10px;
        margin: 10px;
        background-color: rgba(49, 50, 68, 0.9);
        color: #cdd6f4;
        border: 1px solid rgba(137, 180, 250, 0.3);
      }
      
      #outer-box {
        margin: 5px;
      }
      
      #entry {
        padding: 10px;
        border-radius: 0px;
      }
      
      #entry:selected {
        background-color: rgba(137, 180, 250, 0.3);
      }
      
      #text {
        color: #cdd6f4;
      }
    '';
  };

  # Clipboard history service
  services.cliphist.enable = true;
}
