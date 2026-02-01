{ config, pkgs, ... }:

{
  imports = [
    ./apps/git.nix
    ./apps/nushell.nix  # The only place Nushell should be mentioned!
    ./apps/neovim.nix
    ./apps/starship.nix
    ./apps/tmux.nix
  ];

  # Install packages needed by our configs (e.g., for neovim clipboard)
  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    zoxide
    tldr
    nodejs
    xsel # For neovim clipboard
    entr # Trigger events based on file systems updates (and other?)
    pandoc
    devd
  ];

}
