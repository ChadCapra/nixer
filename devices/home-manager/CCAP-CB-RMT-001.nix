{
  hostname = "CCAP-CB-RMT-001";
  osHostname = "penguin"; # Maps to ChromeOS Crostini
  hostPlatform = "aarch64-linux";
  imports = [
    ../../hardware/generic-arm-aarch64.nix
    ../../os/linux-home-manager.nix
  ];
}
