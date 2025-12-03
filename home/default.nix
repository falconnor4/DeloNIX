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

        # Scratchpad
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
      ];
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
