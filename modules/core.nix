{ pkgs, ... }:

{
  # This is your "Core" suite.
  # It contains tools that EVERY machine you own should have.
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
    # Add other "must haves" here
  ];

  # Example: You can also enforce settings here
  # programs.git.enable = true;
}
