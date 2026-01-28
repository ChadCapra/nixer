local opt = vim.opt

-- General settings
opt.number = true
opt.relativenumber = true
opt.smartindent = true

-- Tabs and indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false -- You had this as false, which means you use actual tabs.

-- Clipboard
opt.clipboard = "unnamedplus"
