{ config, pkgs, ... }: 
let nxr = config.nixer; in
{
  # 1. System Variables for Default Editor
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # 2. The Packages & Wrappers
  home.packages = with pkgs; [
    neovim
    nodejs
    lua-language-server
    nil               # Nix LSP
    
    # Create system-wide executable wrappers instead of relying on shell aliases
    (writeShellScriptBin "vi" ''exec nvim "$@"'')
    (writeShellScriptBin "vim" ''exec nvim "$@"'')
  ];

  # 3. The Live, Rebuild-Free Configuration Link
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${nxr.user.dotfiles}/nvim";
}
