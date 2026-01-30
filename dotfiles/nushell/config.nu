# Do not show the banner at startup
$env.config.show_banner = false

# Aliases
alias ll = ls -l
alias gs = git status

# The "Smart" Rebuild
# Automatically detects if we are on NixOS (T14) or Debian (Chromebook)
def rebuild [] {
    print "Rebuilding System..."
    
    # Go to the flake directory
    cd ~/nixer
    
    # Check if the special NixOS file exists
    if ("/etc/NIXOS" | path exists) {
        # T14 Mode
        sudo nixos-rebuild switch --flake ".#t14"
    } else {
        # Chromebook Mode
        home-manager switch --flake ".#penguin"
    }
}
