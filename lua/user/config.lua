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
	relativenumber = true
}

for k, v in pairs(configs) do
	vim.opt[k] = v
end

vim.cmd 'colorscheme gruvbox-material'

vim.cmd 'set path+=/usr/include/c++/11.2.0/'
