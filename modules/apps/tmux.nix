{ config, pkgs, ... }:
let nxr = config.nixer; in
{
  # Install CLI programs
  programs.tmux = {
    enable = true;
  };

  # UPGRADE: We are moving to ~/.config/tmux/tmux.conf
  # Ensure your dotfiles folder has 'tmux/tmux.conf', NOT just 'tmux.conf'
  xdg.configFile."tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink 
    "${nxr.user.dotfiles}/tmux.conf";
}
