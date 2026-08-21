{
  nixer.host.logicalId = "CCAP-CB-RMT-002";
  
  nixer.taxonomy = {
    isa = "x86_64";
    hardwarePlatform = "uefi";
    primaryOs = "chromeos";
    executionEnvironment = "lxc_container";
  };

  imports = [
    ../os/linux-home-manager.nix
  ];
}
