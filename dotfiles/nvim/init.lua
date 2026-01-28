-- Set mapleader before any plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Require other config files
require("user.options")
require("user.keymaps")

-- Setup lazy.nvim with our plugin spec
require("lazy").setup("user.plugins")

-- Set the colorscheme after plugins are loaded
vim.cmd.colorscheme 'cyberdream'
