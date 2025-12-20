{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [
    ];

  # Bootloader.
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.lanzaboote = {
    enable = false;
    pkiBundle = "/etc/secureboot";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles"; # Set your time zone.

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # User account
  users.users.falconnor4 = {
    isNormalUser = true;
    description = "Connor";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix Configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Create a custom session file for Hyprland so SDDM can find it
  # Note: Hyprland usually installs a session file, checking if it's needed explicitly
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "falconnor4";
  services.displayManager.defaultSession = "hyprland";

  # Graphics
  hardware.graphics.enable = true;

  # Security
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Bluetooth - Ensure full Bluetooth stack for Hyprpanel
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  services.blueman.enable = true;

  # UPower for battery monitoring (required by Hyprpanel)
  services.upower.enable = true;

  # Qt theming for KDE apps like Dolphin (override Stylix defaults)
  qt = {
    enable = true;
    platformTheme = lib.mkForce "qt5ct";
    style = lib.mkForce "breeze";
  };

  # Hyprland
  # Hyprland
  programs.hyprland.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  # programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland; # Use stock nixpkgs version for stability
  
  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-hyprland 
    ]; 
    config.common.default = [ "gtk" ];
  };
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Nix-LD
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    sbctl # For Lanzaboote
    metasploit
    # shodan # Check if shodan is in nixpkgs, otherwise might need python package
    (python3.withPackages(ps: with ps; [ shodan ]))
    nixos-generators
    inputs.nix-alien.packages.${pkgs.system}.nix-alien
    inputs.comma.packages.${pkgs.system}.comma
    
    # Additional useful system packages
    btop # Better top for system monitoring
    eza # Modern ls replacement
    bat # Better cat with syntax highlighting
    ripgrep # Fast grep replacement
    fd # Better find
    fzf # Fuzzy finder
    zoxide # Smart cd replacement
    duf # Better df
    ncdu # Disk usage analyzer
    htop # Classic system monitor
    kdePackages.polkit-kde-agent-1 # Polkit authentication agent
    seahorse # GUI for gnome-keyring
    xdg-utils # For opening URLs
    
    # Qt theming for Dolphin
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.breeze
    kdePackages.breeze-icons
    
    # Rust development
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];

  # Stylix
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.targets.gtk.enable = true;
  stylix.targets.gnome.enable = true;
  stylix.targets.qt.enable = true;


  stylix.image = ../../wallpaper.png;
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml"; # Commented out for dynamic colors from image
  stylix.polarity = "dark";
  
  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
  };

  stylix.opacity = {
    terminal = 0.95;
    applications = 1.0;
    desktop = 1.0;
    popups = 1.0;
  };

  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  system.stateVersion = "23.11"; 
}
