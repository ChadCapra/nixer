{ pkgs, ... }:

{
  # Tell Home Manager to use the system's pkgs (inheriting allowUnfree = true)
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.capsc = {
	  imports = [
		# 1. The Contract
		../../lib/options.nix

		# 2. The Data (Manifest)
		../../users/chad.nix

		# 3. The Logic (Profile)
		../../modules/core.nix
		../../modules/creative.nix 
	  ];

    home.stateVersion = "25.11";
  };
}
