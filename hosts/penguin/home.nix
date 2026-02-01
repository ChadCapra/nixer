{ pkgs, ... }:

{
  imports = [
    # 1. The Contract
    ../../lib/options.nix

    # 2. The Data (Manifest)
    ../../users/chad.nix

    # 3. The Logic (Profile)
    ../../modules/core.nix
    ../../modules/creative.nix 
  ];

  programs.home-manager.enable = true;
  
  home.username = "chadcapra";
  home.homeDirectory = "/home/chadcapra";
  home.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;
}
