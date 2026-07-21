{ lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
  
  # Apple's XNU kernel handles all hardware routing.
}
