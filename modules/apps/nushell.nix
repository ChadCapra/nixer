{ pkgs, config, lib, ... }:

let
  # Define the path to your dotfiles explicitly
  dotfiles = "${config.home.homeDirectory}/nixer/dotfiles/nushell";
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
      source ${dotfiles}/config.nu
    '';

    extraEnv = ''
      source ${dotfiles}/env.nu
    '';
  };

  # 3. Dependencies
  # These will now auto-inject their setup scripts into the generated config.nu
  # WITHOUT conflicting with your file.
  programs.carapace.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  # --- Shell Setup ---
  home.sessionVariables = {
    SHELL = "${pkgs.nushell}/bin/nu";
  };

  home.file.".bash_profile".text = ''
    export SHELL=${pkgs.nushell}/bin/nu
    exec ${pkgs.nushell}/bin/nu
  '';
}
