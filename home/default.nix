{ config, pkgs, inputs, ... }:

{
  home.username = "connor";
  home.homeDirectory = "/home/connor";

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

      vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash after first build failure
    })

    # Fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # Cloud Storage
    rclone

    # Gaming
    inputs.lsfg-vk-flake.packages.${pkgs.system}.default
  ];

  # Hyprland User Config
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Basic Hyprland configuration
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, kitty"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating,"
        "$mod, R, exec, wofi --show drun"
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle
        "$mod, L, exec, hyprlock" # Lock screen

        # Scratchpad
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
      ];
      
      exec-once = [
        "waybar"
        "dunst"
        "hypridle"
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
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "battery" "tray" ];
      };
    };
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

  # Stylix is configured system-wide, but can be overridden here if needed

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
