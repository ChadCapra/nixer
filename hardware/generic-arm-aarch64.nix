{ lib, ... }:

{
  # Architecture is explicitly injected by flake.nix during Home Manager evaluation.
  # No kernel modules or bootloaders are declared here.
  # The host OS (e.g., ChromeOS or Debian) manages the physical hardware.
}
