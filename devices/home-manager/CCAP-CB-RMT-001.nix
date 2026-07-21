{
  hostname = "CCAP-CB-RMT-001";
  osHostname = "penguin"; # Maps to ChromeOS Crostini
  imports = [
    ../../hardware/generic-arm-aarch64.nix
    ../../os/linux-home-manager.nix
  ];
}
