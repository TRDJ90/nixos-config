local vim = vim
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '

-- Nvim tree mappings
keymap('n', '<leader>t', ':NvimTreeToggle<CR>', opts)
keymap('n', '<leader>gt', ':NvimTreeFocus<CR>', opts)

-- Telescope mappings 
keymap('n', '<leader>ff', ':Telescope find_files <CR>', opts)
keymap('n', '<leader>fg', ':Telescope live_grep <CR>', opts)
