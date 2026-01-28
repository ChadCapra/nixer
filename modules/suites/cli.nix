{ config, pkgs, ... }:

{
  # Install CLI programs
  programs.git = {
    enable = true;
  };

  # Enable the programs, but configure them with dotfiles
  programs.neovim = {
    enable = true;
    # Create aliases for vi and vim
    viAlias = true;
    vimAlias = true;
  };

  programs.starship.enable = true;

  # Install packages needed by our configs (e.g., for neovim clipboard)
  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    tmux
    zoxide
    nushell
    starship
    tldr
    nodejs
    xsel # For neovim clipboard
    nushell
  ];

  # --- DOTFILE MANAGEMENT ---
  # This section links the files from our `dotfiles` directory
  # into the correct locations in the user's home directory.

# Link Neovim
  xdg.configFile."nvim".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixer/dotfiles/nvim";

  # Link Starship
  xdg.configFile."starship.toml".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixer/dotfiles/starship.toml";

  # Link Tmux
  home.file.".tmux.conf".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixer/dotfiles/tmux.conf";

  # Link config.nu
  home.file.".config/nushell/config.nu".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixer/dotfiles/nushell/config.nu";

  # Link env.nu
  home.file.".config/nushell/env.nu".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixer/dotfiles/nushell/env.nu";

  # --- SHELL SETUP ---
  # Set default shell to nushell and auto load on start (even on chromebook vm)
  home.sessionVariables = {
    SHELL = "${pkgs.nushell}/bin/nu";
  };

  home.file.".bash_profile".text = ''
    export SHELL=${pkgs.nushell}/bin/nu
    exec ${pkgs.nushell}/bin/nu
  '';
}
