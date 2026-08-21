{ lib, ... }:

{
  options.nixer = {
    host = {
      logicalId = lib.mkOption {
        type = lib.types.str;
        description = "The explicit IT asset tag.";
      };
    };

    taxonomy = {
      isa = lib.mkOption {
        type = lib.types.enum [ "x86_64" "aarch64" "riscv64" ];
        default = "x86_64";
        description = "Instruction Set Architecture";
      };
      hardwarePlatform = lib.mkOption {
        type = lib.types.enum [ "uefi" "bios_legacy" "apple_iboot" "u_boot" "locked_firmware" ];
        default = "uefi";
        description = "Hardware/Boot Firmware boundary";
      };
      primaryOs = lib.mkOption {
        type = lib.types.enum [ "linux" "windows" "darwin" "chromeos" "android" ];
        default = "linux";
        description = "Primary operating system kernel";
      };
      executionEnvironment = lib.mkOption {
        type = lib.types.enum [ "nixos" "non_nixos" "lxc_container" "wsl2_hyperv" "chroot_sandbox" ];
        default = "non_nixos";
        description = "Execution boundary for Nix";
      };
    };

    user = {
      name = lib.mkOption { type = lib.types.str; default = "Unknown"; };
      email = lib.mkOption { type = lib.types.str; default = "unknown@example.com"; };
      dotfiles = lib.mkOption { 
        type = lib.types.str; # Changed from lib.types.path to prevent Nix store coercion
        description = "Absolute string path to the live dotfiles source."; 
      };
    };
  };
}
