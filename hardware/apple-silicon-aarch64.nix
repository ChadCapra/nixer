{ lib, ... }:

{
  # Architecture
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # Apple's native kernel handles all physical peripheral routing.
}
