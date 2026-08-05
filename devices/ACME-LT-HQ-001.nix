{
  nixer.host.logicalId = "ACME-LT-HQ-001";
  
  nixer.taxonomy = {
    isa = "x86_64";
    hardwarePlatform = "uefi";
    primaryOs = "linux";
    executionEnvironment = "nixos";
  };

  # Direct hardware configuration constraints remain for bare metal control
  imports = [
    ../hardware/amd-amdgpu-x86_64.nix
    ../os/nixos-core.nix
    ../os/desktops/plasma.nix
  ];
}
