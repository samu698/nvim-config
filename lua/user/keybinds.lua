local keymap = vim.keymap.set

keymap('', '<space>', '<nop>', {})
vim.g.mapleader = ' '

keymap('n', ';', ':', {})				-- fast command mode
keymap('n', "'", ':noh<CR>', {})		-- remove selection
keymap('n', 'U', '<C-r>', {})			-- fast redo
keymap('n', '<Tab>', '<C-o>', {})		-- Tab for going back
keymap('n', '<S-Tab>', '<C-i>', {})		-- S-Tab for going forward
keymap('i', '<C-w>', '<esc><C-w>', {})	-- C-w in insert mode
keymap('n', '<CR>', '<C-a>', {})		-- Increment number with CR
keymap('n', '<BS>', '<C-x>', {})		-- Decrement number with BS

-- Run code with make run
keymap('n', '<leader>w', ':TermExec cmd="make run"<CR>', { noremap = true, silent = true })
-- Easier way to escape the terminal
keymap('t', '<Del>', '<C-\\><C-n>', {noremap = true})

local ok, pickers = pcall(require, 'telescope.builtin')
if ok then
	function find_files()
		pickers.find_files {
			find_command = {
				'find',
				'-type', 'f',
				'-maxdepth', '5',
				'-not', '-path', '*/.*/*',
				'-not', '-path', '*/target/*',
				'-not', '-name', 'Cargo.lock',
			}
		}
	end

	keymap('n', '<leader>f', find_files, {})

	function git_or_files()
		local commit_count = tonumber(vim.fn.system('git rev-list --all --count'))
		if vim.v.shell_error == 0 then
			if commit_count ~= 0 and commit_count ~= nil then
				pickers.git_files()
			else
				vim.print 'No commits in git repository, falling back to file view'
				find_files()
			end
		else
			vim.print 'Not inside a git repository, falling back to file view'
			find_files()
		end
	end

	keymap('n', '<leader>g', git_or_files, {})
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
