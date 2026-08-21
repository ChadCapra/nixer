{
  description = "The Nixer System";

  inputs = {
    # Pin core package streams strictly to the 26.05 release cycle
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    lib = nixpkgs.lib;

    # 1. Discover all hardware ledgers in the unified devices directory
    deviceFiles = if builtins.pathExists ./devices
                  then builtins.filter (lib.strings.hasSuffix ".nix") (builtins.attrNames (builtins.readDir ./devices))
                  else [];

    # 2. Pre-evaluate taxonomy for routing
    devices = builtins.map (file:
      let
        hostName = lib.removeSuffix ".nix" file;
        meta = lib.evalModules {
          modules = [ (./devices + "/${file}") ./lib/options.nix { _module.check = false; } ];
        };
        tax = meta.config.nixer.taxonomy;
        host = meta.config.nixer.host;
        
        # Map physical taxonomy to Nix's internal target architecture strings
        arch = if tax.isa == "aarch64" && tax.primaryOs == "darwin" then "aarch64-darwin"
               else if tax.isa == "x86_64" && tax.primaryOs == "darwin" then "x86_64-darwin"
               else if tax.isa == "aarch64" then "aarch64-linux"
               else "x86_64-linux";
      in {
        inherit hostName arch tax host file;
      }
    ) deviceFiles;

    # 3. Route to pipelines based strictly on the Execution Environment boundary
    nixosDevices = builtins.filter (d: d.tax.executionEnvironment == "nixos") devices;
    hmDevices = builtins.filter (d: d.tax.executionEnvironment != "nixos") devices;

  in {

    # =========================================================================
    # PIPELINE A: NIXOS (Multi-User Bare Metal)
    # =========================================================================
    nixosConfigurations = builtins.listToAttrs (builtins.map (d: {
      name = d.hostName;
      value = lib.nixosSystem {
        system = d.arch;
        specialArgs = { inherit inputs; };
        modules = [
          ./lib/options.nix
          (./devices + "/${d.file}")
          home-manager.nixosModules.default
          ({ pkgs, ... }: {
            networking.hostName = d.hostName;
            
            # Global NixOS permission for proprietary components
            nixpkgs.config.allowUnfree = true;

            users.users = builtins.mapAttrs (uKey: uData: {
              isNormalUser = true;
              description = uData.identity.name;
              extraGroups = [ "networkmanager" "wheel" ];
              shell = pkgs.bash;
            }) (import ./lib/get-authorized-users.nix { inherit lib; hostName = d.hostName; });

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = builtins.mapAttrs (uKey: uData: {
              imports = (map (role: ./modules/${role}.nix) uData.roles) ++ [ ./lib/options.nix ];
              home.username = uData.identity.username;
              home.homeDirectory = "/home/${uData.identity.username}";
              home.stateVersion = uData.identity.homeVersion;

              nixer.user.name = uData.identity.name;
              nixer.user.email = uData.identity.email;
              nixer.user.dotfiles = "/home/${uData.identity.username}/nixer/dotfiles";
            }) (import ./lib/get-authorized-users.nix { inherit lib; hostName = d.hostName; });
          })
        ];
      };
    }) nixosDevices);

    # =========================================================================
    # PIPELINE B: HOME MANAGER (Multi-User Containers/WSL/Etc)
    # =========================================================================
    homeConfigurations = builtins.listToAttrs (lib.flatten (builtins.map (d:
      let
        auth = import ./lib/get-authorized-users.nix { inherit lib; hostName = d.hostName; };
        osHost = if d.host.osId != null then d.host.osId else d.hostName;
        
        # Instantiate a custom unfree-enabled package set specifically for this architecture pass
        unfreePkgs = import nixpkgs {
          system = d.arch;
          config.allowUnfree = true;
        };
      in
      lib.mapAttrsToList (userKey: userData: {
        name = "${userData.identity.username}@${osHost}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = unfreePkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./lib/options.nix
            (./devices + "/${d.file}")
            ({ ... }: {
              imports = (map (role: ./modules/${role}.nix) userData.roles) ++ [ ./lib/options.nix ];
              home.username = userData.identity.username;
              home.homeDirectory = "/home/${userData.identity.username}";
              home.stateVersion = userData.identity.homeVersion;

              nixer.user.name = userData.identity.name;
              nixer.user.email = userData.identity.email;
              nixer.user.dotfiles = "/home/${userData.identity.username}/nixer/dotfiles";
            })
          ];
        };
      }) auth
    ) hmDevices));
  };
}
