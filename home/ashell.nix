{ config, pkgs, inputs, lib, ... }:

{
  # ashell - Rust-based Wayland status bar for Hyprland
  home.packages = with pkgs; [ 
    ashell
    cliphist  # Clipboard manager for clipboard module
  ];

  # ashell configuration (TOML format)
  xdg.configFile."ashell/config.toml".text = ''
    # Ashell Configuration - Laptop-friendly setup similar to GNOME
    log_level = "warn"
    
    # Show on all outputs
    outputs = "All"
    
    # Bar position
    position = "Top"
    
    # App launcher command (wofi)
    app_launcher_cmd = "wofi --show drun"
    
    # Module layout
    [modules]
    # Left: App launcher, Workspaces, Active window
    left = [ "AppLauncher", "Workspaces", "WindowTitle" ]
    
    # Center: Media player (like GNOME's media controls)
    center = [ "MediaPlayer" ]
    
    # Right: System info, Privacy, Tray, Clock, Settings panel
    right = [ "SystemInfo", "Privacy", "Tray", "Clock", "Settings" ]
    
    # Workspaces module config
    [workspaces]
    enable_workspace_filling = true
    
    # Window title config
    [window_title]
    truncate_title_after_length = 50
    
    # System info (CPU, RAM, Temperature - great for laptops)
    [system_info]
    cpu = true
    memory = true
    temperature = true
    
    # Clock configuration
    [clock]
    format = "%a %b %d  %H:%M"
    
    # Settings panel - GNOME-like quick settings
    [settings]
    # Lock command
    lock_cmd = "hyprlock"
    
    # Audio settings (clicking opens pavucontrol)
    audio_sinks_more_cmd = "pavucontrol -t 3"
    audio_sources_more_cmd = "pavucontrol -t 4"
    
    # Network settings
    wifi_more_cmd = "nm-connection-editor"
    vpn_more_cmd = "nm-connection-editor"
    
    # Bluetooth settings
    bluetooth_more_cmd = "blueman-manager"
    
    # Enable all laptop-essential features
    [settings.battery]
    enable = true
    
    [settings.audio]
    enable = true
    
    [settings.brightness]
    enable = true
    
    [settings.network]
    enable = true
    
    [settings.bluetooth]
    enable = true
    
    [settings.power_profiles]
    enable = true
    
    [settings.idle_inhibitor]
    enable = true
    
    [settings.airplane_mode]
    enable = true
    
    [settings.power_menu]
    enable = true
    lock_cmd = "hyprlock"
    logout_cmd = "hyprctl dispatch exit"
    sleep_cmd = "systemctl suspend"
    reboot_cmd = "systemctl reboot"
    shutdown_cmd = "systemctl poweroff"
    
    # Appearance - Modern floating style
    [appearance]
    style = "Floating"
    transparency = true
    
    # Colors will follow system theme, but we can set some basics
    height = 36
    border_radius = 12
  '';

  # Clipboard history service (for clipboard module)
  services.cliphist.enable = true;

  # Notifications - using mako (lightweight, like GNOME notifications)
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 12;
      width = 350;
      height = 100;
      margin = "10";
      padding = "15";
      icons = true;
      max-icon-size = 48;
      layer = "overlay";
      anchor = "top-right";
    };
  };

  # Wofi launcher (GNOME-like app search)
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
}
