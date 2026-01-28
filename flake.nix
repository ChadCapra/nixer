{
  description = "The Capra Unified System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    
    # 1. NixOS Configurations (Your T14)
    nixosConfigurations = {
      "t14" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/t14/default.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };

    # 2. Home Manager Configurations (Your Chromebook)
    homeConfigurations = {
      "penguin" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./hosts/penguin/home.nix
        ];
      };
    };
    
  };
}
