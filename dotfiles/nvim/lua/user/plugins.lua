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
}
