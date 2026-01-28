{ pkgs, ... }:

{
  # Import the Shared Suites
  imports = [
    ../../modules/suites/cli.nix
    ../../modules/suites/creative.nix 
  ];

  # Chromebook specific settings
  home.username = "chadcapra";
  home.homeDirectory = "/home/chadcapra";
  home.stateVersion = "25.11";

  # Pass variables to the suites (Fixes the git warnings too!)
  programs.git.settings.user.name = "Chad Capra";
  programs.git.settings.user.email = "chadcapra@gmail.com";
  
  # Allow non-free packages (if needed for chrome/codecs)
  nixpkgs.config.allowUnfree = true;
}
