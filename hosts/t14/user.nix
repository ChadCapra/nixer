{ pkgs, ... }:

{
  home-manager.users.capsc = {
    imports = [
      # Import the suites we just made
      ../../modules/suites/cli.nix
      ../../modules/suites/creative.nix
    ];

    home.stateVersion = "25.11";
    
    # PASS VARIABLES TO SUITES
    # This fixes the "userSettings" error from your old code
    programs.git.settings.user.name = "Chad Capra";
    programs.git.settings.user.email = "chadcapra@gmail.com";
  };
}
