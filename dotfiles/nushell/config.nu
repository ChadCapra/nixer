# Do not show the banner at startup
$env.config.show_banner = false

# Aliases
alias ll = ls -l
alias gs = git status

# A custom command that moves to the directory and builds
def rebuild [] {
    # 1. Use ~ safely to go to the folder
    cd ~/nixer

    # 2. Run the build (using . since we are now in the right spot)
    # We quote ".#t14" to protect the # hash symbol
    sudo nixos-rebuild switch --flake ".#t14"
}
