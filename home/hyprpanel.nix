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
        launcher.autoDetectIcon = true;
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
      
      # Dashboard settings
      menus.dashboard = {
        directories.enabled = true;
        stats.enable_gpu = false;
        powermenu.enabled = true;
        shortcuts.enabled = true;
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
      
      # Theme settings - Bubbly look
      theme = {
        bar = {
          transparent = true;
          floating = true;
          
          # Button styling for bubbly appearance
          buttons = {
            enableBorders = true;
            radius = lib.mkForce "12px";
            padding_x = lib.mkForce "4px";
            padding_y = lib.mkForce "2px";
            spacing = lib.mkForce "0em";
            background = lib.mkForce "rgba(30, 30, 46, 0.85)";
            borderColor = lib.mkForce "rgba(137, 180, 250, 0.4)";
          };
          
          # Floating bar margins - flush layout
          margin_top = lib.mkForce "0px";
          margin_sides = lib.mkForce "0px";
          margin_bottom = lib.mkForce "0px";
          
          # Bar outer styling - minimal spacing
          outer_spacing = lib.mkForce "0px";
          border_radius = lib.mkForce "0px";
        };
        
        font = {
          name = lib.mkForce "CaskaydiaCove NF";
          size = lib.mkForce "13px";
        };
        
        # Notification styling to match
        notification = {
          border_radius = lib.mkForce "16px";
        };
        
        # Menu styling to match
        menu = {
          border_radius = lib.mkForce "16px";
        };
        
        # OSD styling
        osd = {
          border_radius = lib.mkForce "16px";
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
        border-radius: 12px;
        background-color: rgba(30, 30, 46, 0.95);
      }
      
      #input {
        border-radius: 8px;
        padding: 10px;
        margin: 10px;
        background-color: rgba(49, 50, 68, 0.9);
        color: #cdd6f4;
      }
      
      #outer-box {
        margin: 5px;
      }
      
      #entry {
        padding: 10px;
        border-radius: 8px;
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
