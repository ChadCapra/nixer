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
opt.clipboard = ""


-- Explicitly yank to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Explicitly paste from system clipboard
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])
vim.keymap.set({"n", "v"}, "<leader>P", [["+p]])
