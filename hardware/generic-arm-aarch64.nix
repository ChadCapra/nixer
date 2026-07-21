{ lib, ... }:

{
  # Architecture
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  
  # No kernel modules or bootloaders are declared here.
  # The host OS (e.g., ChromeOS or Debian) manages the physical hardware.
}
