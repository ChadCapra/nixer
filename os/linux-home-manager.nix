{ config, pkgs, ... }:

{
  # This file establishes that we are a guest in a Linux container.
  programs.home-manager.enable = true;

  # Universal settings for user-space Linux
  fonts.fontconfig.enable = true;
  targets.genericLinux.enable = true; # Helps map XDG directories correctly
}
