{ config, pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    opencode
  ];

  # Future opencode configuration can be added here
}
