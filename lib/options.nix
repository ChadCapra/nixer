{ lib, config, ... }:

{
  options.nixer = {
    user = {
      name = lib.mkOption { type = lib.types.str; };
      email = lib.mkOption { type = lib.types.str; };
      dotfiles = lib.mkOption { 
        type = lib.types.path; 
        default = config.home.homeDirectory + "/nixer/dotfiles";
        description = "Absolute path to the dotfiles source.";
      };
    };
  };
}
