return {
  -- Colorscheme
  { "scottmckendry/cyberdream.nvim" },

  -- Statusline
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- File Explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- Fuzzy Finder
  { 'nvim-telescope/telescope.nvim', tag = '0.1.6', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Keymap helper
  { 'folke/which-key.nvim', opts = {} },

  -- Icons
  { "nvim-tree/nvim-web-devicons" },

  -- Tree-sitter for Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Tells lazy exactly which module to load safely
    opts = {
      -- A list of parser names, or "all"
      ensure_installed = { 
        "elixir", "eex", "heex", "svelte", 
        "nix", "lua", "bash", "markdown", "markdown_inline" 
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
  },

  -- LSP Config (The bridge between Neovim and your Nix devShells)
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- 1. Override default settings for specific servers
      -- We use tbl_deep_extend to merge our custom 'cmd' with the built-in defaults safely
      vim.lsp.config.elixirls = vim.tbl_deep_extend(
        "force",
        vim.lsp.config.elixirls or {},
        { cmd = { "elixir-ls" } }
      )

      -- 2. Enable the language servers
      vim.lsp.enable("elixirls")
      vim.lsp.enable("svelte")
      vim.lsp.enable("nixd")
    end,
  },
}
