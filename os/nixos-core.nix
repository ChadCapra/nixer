{ config, pkgs, ... }:

{
  # Audio and core daemons
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  services.printing.enable = true;
}
