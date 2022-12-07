local keymap = vim.keymap.set

keymap('', '<space>', '<nop>', {})
vim.g.mapleader = ' '

keymap('n', ';', ':', {})				-- fast command mode
keymap('n', "'", ':noh<CR>', {})		-- remove selection
keymap('n', 'U', '<C-r>', {})			-- fast redo
keymap('n', '<Tab>', '<C-o>', {})		-- Tab for going back
keymap('n', '<S-Tab>', '<C-i>', {})		-- S-Tab for going forward
keymap('i', '<C-z>', '<esc><C-z>', {})	-- C-z in insert mode
keymap('i', '<C-w>', '<esc><C-w>', {})	-- C-w in insert mode

-- Run code with make run
keymap('n', '<leader>w', ':TermExec cmd="make run"<CR>', { noremap = true, silent = true })
-- Keymaps for terminal
keymap('t', '<esc>', '<C-\\><C-n>', {noremap = true})
keymap('t', '<C-Z>', '<C-\\><C-n><C-Z>', {noremap = true})
keymap('t', '<F2>', '<esc>', { noremap = true })

local ok, pickers = pcall(require, 'telescope.builtin')
if ok then
	keymap('n', '<leader>g', pickers.git_files, {})
	keymap('n', '<leader>f', pickers.find_files, {})

	function man_pages()
		pickers.man_pages { sections = { "2", "3", "3p", "3type", "7" } }
	end

	keymap('n', '<leader>m', man_pages, {})
end

function toggle_invisible()
	if vim.opt.list._value then
		vim.cmd 'IndentBlanklineEnable'
		vim.opt.list = false
	else
		vim.cmd 'IndentBlanklineDisable'
		vim.opt.list = true
		vim.opt.listchars:append 'space:'
		vim.opt.listchars:append 'eol:↴'
		vim.opt.listchars:append 'tab: '
	end
end

keymap('n', '<leader>h', toggle_invisible, {noremap = true})
