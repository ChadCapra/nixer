{
  nixer.host.logicalId = "CCAP-CB-RMT-001";
  nixer.host.osId = "penguin";
  
  nixer.taxonomy = {
    isa = "aarch64";
    hardwarePlatform = "uefi"; 
    primaryOs = "chromeos";
    executionEnvironment = "lxc_container";
  };

  system.stateVersion = "26.05";

  imports = [
    ../os/linux-home-manager.nix
  ];
}
