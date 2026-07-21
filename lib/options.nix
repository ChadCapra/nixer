{ lib, config, ... }:

{
  options = {
    # Declare asset tag options so the module engine accepts them
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "The logical IT asset tag for this device.";
    };
    
    osHostname = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The literal OS hostname, if different from the logical asset tag.";
    };

    nixer = {
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
  };
}
