local vim = vim
local opt = vim.opt
local wo = vim.wo

-- Colorschemes general
opt.termguicolors = true
opt.background = "dark"

-- UI settings
wo.cursorline = true
vim.api.nvim_set_option('cmdheight', 2)
opt.laststatus = 3
-- opt.winbar = "%=%m %f"

wo.number = true
wo.relativenumber = true
opt.numberwidth = 4
opt.wrap = false

-- completion
opt.completeopt = { "menuone", "noselect", "menu" }
opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

-- tab setting
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.fillchars = 'eob: '
