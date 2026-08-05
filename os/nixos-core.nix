{ config, pkgs, lib, ... }:

{
  # Audio and core daemons
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.printing.enable = true;

  # Fallback filesystem definitions to satisfy strict evaluation checks (e.g., nix flake check).
  # These are defined via lib.mkDefault so your actual physical hardware allocations take full precedence.
  fileSystems."/" = lib.mkDefault { 
    device = "/dev/disk/by-label/nixos"; 
    fsType = "ext4"; 
  };
}
