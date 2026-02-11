{ config, pkgs, ... }:
let nxr = config.nixer; in
{
	programs.direnv = {
		enable = true;
		enableNushellIntegration = true; # Critical for you
		nix-direnv.enable = true;        # Caches the shell so it's instant
	};
}
