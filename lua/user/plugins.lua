local ok, packer = pcall(require, 'packer')
if not ok then
	return
end

packer.init {
	package_root = vim.fn.stdpath('config') .. '/pack',
	display = {
		open_fn = function() 
			return require('packer.util').float { border = 'rounded' }
		end
	}
}

return packer.startup(function(use)
	use 'wbthomason/packer.nvim'
	
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'

	use 'sainnhe/gruvbox-material'

	use 'nvim-lualine/lualine.nvim'

	use 'norcalli/nvim-colorizer.lua'

	use 'lukas-reineke/indent-blankline.nvim'

	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	use 'samu698/autoIndent.nvim'

	use 'akinsho/toggleterm.nvim'

	use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { {'nvim-lua/plenary.nvim'} } }

	use "windwp/nvim-autopairs"
end)
