{ config, lib, ... }:

{
  # Architecture
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Intel-specific kernel and microcode
  boot.kernelModules = [ "kvm-intel" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Standard Intel storage and peripheral drivers
  boot.initrd.availableKernelModules = [ 
    "xhci_pci" 
    "ahci" 
    "usb_storage" 
    "sd_mod" 
    "rtsx_pci_sdmmc" 
  ];

  # Bootloader mapping
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
