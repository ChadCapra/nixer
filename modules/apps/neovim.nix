{ pkgs, config, lib, ... }: 

{
  # 1. THE HYBRID ENGINE (The "Smart" Install)
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
  };

  # 2. THE DEPENDENCIES (The "Dumb" Install)
  # Tools that Neovim specifically needs to function
  home.packages = with pkgs; [
    xsel              # Clipboard
    ripgrep           # Telescope grep
    fd                # Telescope find
    lua-language-server
    nil               # Nix LSP
  ];

  # 3. THE CONFIGURATION (The Symlink)
  # This links ~/.config/nvim to your local repo
  # Note: We adjust the path relative to THIS file
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink 
    "${config.home.homeDirectory}/nixer/dotfiles/nvim";
    
}
