{
  services.xserver.enable = true;
  
  # SDDM is the login screen. It handles both Plasma and Hyprland perfectly.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  
  services.desktopManager.plasma6.enable = true;
}
