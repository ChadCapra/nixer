{ config, pkgs, ... }:

{
  # Install CLI programs
  programs.tmux = {
    enable = true;
  };

  # Link Tmux
  home.file.".tmux.conf".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixer/dotfiles/tmux.conf";

}
