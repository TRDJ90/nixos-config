local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
	print "Installing packer close and reopen Neovim..."
	vim.cmd [[packadd packer.nvim]]
end

-- Use protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end
	},
}

return require('packer').startup(function(use)
	use { "wbthomason/packer.nvim" }

    use { 'kyazdani42/nvim-web-devicons' }
    use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true }}
    use { "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig" }
    use { "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" }
    use { "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" }
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    use { 'tanvirtin/monokai.nvim' }
	use { 'sainnhe/everforest' }
end)