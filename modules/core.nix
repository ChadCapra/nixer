{ pkgs, ... }:

{
  imports = [
    ./apps/direnv.nix
    ./apps/git.nix
    ./apps/nushell.nix
    ./apps/neovim.nix
    ./apps/starship.nix
    ./apps/tmux.nix
  ];

  # Enable Home Manager's bash integration to manage environment variables
  programs.bash.enable = true;

  # Universally add the nixer bin directory to the PATH for all shells
  home.sessionPath = [
    "$HOME/nixer/bin"
  ];

  # System-wide packages that don't need dedicated modules
  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
	fd
    zoxide
    tldr
    nodejs
    xsel    #may be needed on chromebook still, but figure out this later
	wl-clipboard
    entr
    pandoc
    devd
	just
  ];
}
