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
        # NixOS targets are just the hostname
        sudo nixos-rebuild switch --flake $".#(sys host | get hostname)"
    } else {
        # Home Manager targets are user@hostname
        home-manager switch --flake $".#(whoami)@(sys host | get hostname)"
    }
}

 # Auto-launch Sessionizer if not already in Tmux
if ($env.TMUX? | is-empty) {
    home
} 
