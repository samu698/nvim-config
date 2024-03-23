local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not ok then
	return
end

treesitter.setup {
	enure_installed = { 'bash', 'c', 'cpp', 'glsl', 'html', 'javascript', 'css', 'make', 'lua', 'rust', 'java' },
	sync_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	},
	indent = { enable = true },
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
		hlgroups = {
			'RainbowLevel0',
			'RainbowLevel1',
			'RainbowLevel2',
			'RainbowLevel3',
			'RainbowLevel4',
			'RainbowLevel5',
			'RainbowLevel6',
			'RainbowLevel7',
			'RainbowLevel8',
		}
	}
}

-- Create folds based on treesitter's ast
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 999
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*" },
    command = "normal zx",
})
