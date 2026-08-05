{ config, pkgs, ... }: 
let nxr = config.nixer; in
{
  # 1. THE HYBRID ENGINE (The "Smart" Install)
  # We use home.packages instead of programs.neovim to prevent Home Manager
  # from auto-generating an init.lua, which collides with your full directory symlink.
  home.packages = with pkgs; [
    neovim
    nodejs
    lua-language-server
    nil               # Nix LSP
  ];

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${nxr.user.dotfiles}/nvim";
}
