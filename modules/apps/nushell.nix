{ config, lib, pkgs, ... }:

let 
  nxr = config.nixer;
  # Check if we are running inside a full NixOS system.
  # 'osConfig' is only present when Home Manager is a NixOS module.
  isNixOS = config ? osConfig;
in
{
  # 1. The Module
  programs.nushell = {
    enable = true;

    # 2. The Integration
    # We tell Nushell to simply "read" your external files.
    # This allows Home Manager to write its own necessary setup code (Starship, etc)
    # AND load your personal config on top of it.
    
    extraConfig = ''
      source ${nxr.user.dotfiles}/nushell/config.nu
    '';

    extraEnv = ''
      source ${nxr.user.dotfiles}/nushell/env.nu
    '';
  };

  # 3. Dependencies
  # These will now auto-inject their setup scripts into the generated config.nu
  # WITHOUT conflicting with your file.
  programs.carapace.enable = true;
  programs.zoxide.enable = true;

  # --- Shell Setup ---
  # Only apply the "Chromebook Hack" if we are NOT on NixOS.
  # On NixOS, this breaks the login manager (causing blank screens).
#  home.sessionVariables = lib.mkIf (!isNixOS) {
#    SHELL = "${pkgs.nushell}/bin/nu";
#  };
#
#  home.file.".bash_profile" = lib.mkIf (!isNixOS) {
#    text = ''
#      export SHELL=${pkgs.nushell}/bin/nu
#      exec ${pkgs.nushell}/bin/nu
#    '';
#  };
}
