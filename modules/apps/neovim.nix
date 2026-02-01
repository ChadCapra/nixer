{ config, pkgs, ... }: 
let nxr = config.nixer; in
{
  # 1. THE HYBRID ENGINE (The "Smart" Install)
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;

	extraPackages = with pkgs; [
		xsel              # Clipboard
		ripgrep           # Telescope grep
		fd                # Telescope find
		lua-language-server
		nil               # Nix LSP
	  ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink 
    "${nxr.user.dotfiles}/nvim";
}
