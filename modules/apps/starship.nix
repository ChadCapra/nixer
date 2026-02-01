{ pkgs, config, lib, ... }:

{
  programs.starship = {
    enable = true;
    # Integrations are usually enabled by default in HM,
    # but we can be explicit if we want:
    #  enableNushellIntegration = true;
  };

  # The Configuration (Symlink)
  # Linking ~/.config/starship.toml -> ~/nixer/dotfiles/starship.toml
  xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink 
    "${config.home.homeDirectory}/nixer/dotfiles/starship.toml";
}
