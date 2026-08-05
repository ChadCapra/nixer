{
  nixer.host.logicalId = "CCAP-CB-RMT-001";
  nixer.host.osId = "penguin";
  
  nixer.taxonomy = {
    isa = "aarch64";
    hardwarePlatform = "uefi"; 
    primaryOs = "chromeos";
    executionEnvironment = "lxc_container";
  };

  # Generic architecture files are replaced entirely by the taxonomy schema.
  imports = [
    ../os/linux-home-manager.nix
  ];
}
