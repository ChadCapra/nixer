{ config, lib, ... }:

{
  # Architecture
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # AMD-specific kernel and microcode
  boot.kernelModules = [ "kvm-amd" ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Common storage and peripheral drivers for this chassis tier
  boot.initrd.availableKernelModules = [ 
    "nvme" 
    "xhci_pci_renesas" 
    "xhci_pci" 
    "usb_storage" 
    "sd_mod" 
    "rtsx_pci_sdmmc" 
  ];

  # Bootloader mapping
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
