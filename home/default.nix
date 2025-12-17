{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./packages.nix
    ./hyprland.nix
    ./hyprpanel.nix
    ./programs.nix
    ./services.nix
  ];

  # Home Manager
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
