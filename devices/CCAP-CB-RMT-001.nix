{
  nixer.host.logicalId = "CCAP-CB-RMT-001";
  
  nixer.taxonomy = {
    isa = "aarch64";
    hardwarePlatform = "uefi"; 
    primaryOs = "chromeos";
    executionEnvironment = "lxc_container";
  };

  imports = [
    ../os/linux-home-manager.nix
  ];
}
