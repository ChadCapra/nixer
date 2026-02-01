{ pkgs, ... }:

{
  imports = [
    ./apps/git.nix
    ./apps/nushell.nix
    ./apps/neovim.nix
    ./apps/starship.nix
    ./apps/tmux.nix
  ];

  # System-wide packages that don't need dedicated modules
  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    zoxide
    tldr
    nodejs
    xsel
    entr
    pandoc
    devd
  ];
}
