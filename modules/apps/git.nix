{ config, pkgs, ... }:
let nxr = config.nixer; in
{
  programs.git = {
    enable = true;
    
	settings.user = {
		name = nxr.user.name;
    	email = nxr.user.email;
	};
  };
}
