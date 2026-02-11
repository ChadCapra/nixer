local map = vim.keymap.set

map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find Files' })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live Grep' })

-- Duplicate current file (Save As in same directory)
-- 1. Expands the directory of the current file
-- 2. Types ":saveas <dir>/" into the command line
-- 3. Leaves the cursor ready for you to type the new filename
map('n', '<leader>cf', function()
	local current_dir = vim.fn.expand("%:h")
	if current_dir == "" then current_dir = "." end
	local cmd = ":saveas " .. current_dir .. "/"
	vim.api.nvim_feedkeys(cmd, "n", false)
end, { desc = "Copy File (Same Dir)" })
