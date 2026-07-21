{ pkgs, lib, ... }:

let
  hostName = "corp-t14";
  
  # 1. Fetch the dynamic matrix for THIS machine (returns { chad = {...}; bob = {...}; })
  auth = import ../lib/get-authorized-users.nix { inherit lib hostName; };
in
{
  imports = [
    ../hardware/amd-systemd-x86_64.nix
    ../os/nixos-core.nix
    ../os/desktops/plasma.nix
  ];

  networking.hostName = hostName;

  # 2. Dynamically generate the NixOS System Users
  users.users = builtins.mapAttrs (userName: userData: {
    isNormalUser = true;
    description = userData.identity.name;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bash;
  }) auth;

  # 3. Dynamically generate their Home Manager profiles
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  
  home-manager.users = builtins.mapAttrs (userName: userData: {
    # Dynamically map their roles to module paths
    imports = (map (role: ../modules/${role}.nix) userData.roles) ++ [ ../lib/options.nix ];
    
    home.username = userName;
    home.homeDirectory = "/home/${userName}";
    home.stateVersion = "25.11";
  }) auth;
}
