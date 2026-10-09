return {
  -- Colorscheme
  { "scottmckendry/cyberdream.nvim" },

  -- Statusline
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- File Explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- Fuzzy Finder
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Keymap helper
  { 'folke/which-key.nvim', opts = {} },

  -- Icons
  { "nvim-tree/nvim-web-devicons" },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- A protected call prevents Neovim from crashing if the download fails
      local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
      
      if not status_ok then
        vim.notify("Tree-sitter is missing or still downloading. Run :Lazy to check status.", vim.log.levels.WARN)
        return
      end

      treesitter.setup({
        ensure_installed = { 
          "elixir", "eex", "heex", "svelte", 
          "nix", "lua", "bash", "markdown", "markdown_inline" 
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP Config (The bridge between Neovim and your Nix devShells)
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- 1. Override default settings for specific servers
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
