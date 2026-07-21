{
  description = "The Nixer System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    lib = nixpkgs.lib;
    
    # Discovery Engine
    getHosts = dir: 
      if builtins.pathExists dir 
      then builtins.map (file: lib.removeSuffix ".nix" file) (builtins.attrNames (builtins.readDir dir))
      else [];

    nixosHosts = getHosts ./devices/nixos;
    hmHosts = getHosts ./devices/home-manager;

  in {
    
    # =========================================================================
    # PIPELINE A: NIXOS (Multi-User Bare Metal)
    # =========================================================================
    nixosConfigurations = lib.genAttrs nixosHosts (hostName: 
      let 
        auth = import ./lib/get-authorized-users.nix { inherit lib hostName; };
      in
      lib.nixosSystem {
        system = "x86_64-linux"; 
        specialArgs = { inherit inputs; };
        modules = [
          (./devices/nixos + "/${hostName}.nix")
          home-manager.nixosModules.default
          ({ pkgs, ... }: {
            networking.hostName = hostName;
            
            # 1. Generate System Accounts
            users.users = builtins.mapAttrs (u: d: {
              isNormalUser = true;
              description = d.identity.name;
              extraGroups = [ "networkmanager" "wheel" ];
              shell = pkgs.bash;
            }) auth;

            # 2. Generate Home Manager Profiles
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = builtins.mapAttrs (u: d: {
              imports = (map (role: ./modules/${role}.nix) d.roles) ++ [ ./lib/options.nix ];
              home.username = d.identity.username;
              home.homeDirectory = "/home/${d.identity.username}";
              home.stateVersion = "25.11";

              # THE BRIDGE: Pass the pure data into the module options
              nixer.user.name = d.identity.name;
              nixer.user.email = d.identity.email;
            }) auth;
          })
        ];
      }
    );

    # =========================================================================
    # PIPELINE B: HOME MANAGER (Multi-User Containers/WSL)
    # =========================================================================
    # This creates targets like "chadcapra@CCAP-CB-RMT-001" dynamically.
    homeConfigurations = 
      let
        # Build a flat list of { name = "user@host"; value = {...}; }
        allConfigs = lib.flatten (map (hostName: 
          let 
            auth = import ./lib/get-authorized-users.nix { inherit lib hostName; };
            isArm = lib.strings.hasInfix "arm" hostName;
            arch = if isArm then "aarch64-linux" else "x86_64-linux";
          in
          lib.mapAttrsToList (userKey: userData: {
            name = "${userData.identity.username}@${hostName}";
            value = home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${arch};
              extraSpecialArgs = { inherit inputs; };
              modules = [
                (./devices/home-manager + "/${hostName}.nix")
                ({ ... }: {
                  imports = (map (role: ./modules/${role}.nix) userData.roles) ++ [ ./lib/options.nix ];
                  home.username = userData.identity.username;
                  home.homeDirectory = "/home/${userData.identity.username}";
                  home.stateVersion = "25.11";

                  # THE BRIDGE: Pass the pure data into the module options
                  nixer.user.name = userData.identity.name;
                  nixer.user.email = userData.identity.email;
                })
              ];
            };
          }) auth
        ) hmHosts);
      in 
      builtins.listToAttrs allConfigs;
  };
}
