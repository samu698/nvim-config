local configs = {
	termguicolors = true,
	tabstop = 4,
	shiftwidth = 4,
	showmode = false,
	number = true,
	cursorline = true,
	smartindent = true,
	wrap = false,
	showtabline = 1,
	background = 'dark',
	updatetime = 1000,
	mouse = '',
	relativenumber = true,
	ignorecase = true,
	smartcase = true,
	scrolloff = 999,
}

for k, v in pairs(configs) do
	vim.opt[k] = v
end

vim.cmd 'colorscheme gruvbox-material'

vim.cmd 'set path+=/usr/include/c++/11.2.0/'

-- Highlight trailing whitespace
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { ctermbg='red', bg='red' })
vim.cmd [[match TrailingWhitespace /\s\+\%#\@<!$/]]
