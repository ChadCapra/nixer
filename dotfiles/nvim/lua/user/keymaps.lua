local map = vim.keymap.set

map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find Files' })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live Grep' })
