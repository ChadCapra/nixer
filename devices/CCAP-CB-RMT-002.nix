{
  nixer.host.logicalId = "CCAP-CB-RMT-002";
  nixer.host.osId = "penguin";
  
  nixer.taxonomy = {
    isa = "x86_64";
    hardwarePlatform = "uefi";
    primaryOs = "chromeos";
    executionEnvironment = "lxc_container";
  };

  system.stateVersion = "26.05";

  imports = [
    ../os/linux-home-manager.nix
  ];
}
