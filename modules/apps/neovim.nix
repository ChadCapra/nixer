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

    # Core build tools so Lazy and Treesitter can compile parsers (Fixes ft_to_lang crashes)
    gcc
    gnumake
    unzip
	tree-sitter
    
    # Dependencies for Telescope and Mason (Most Mason LSPs require Node)
    ripgrep
    fd
    nodejs

    # Fallback LSPs
    lua-language-server
    nil               # Nix LSP
    elixir-ls
    svelte-language-server

    # Create system-wide executable wrappers instead of relying on shell aliases
    (writeShellScriptBin "vi" ''exec nvim "$@"'')
    (writeShellScriptBin "vim" ''exec nvim "$@"'')
  ];

  # 3. The Live, Rebuild-Free Configuration Link
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${nxr.user.dotfiles}/nvim";
}
