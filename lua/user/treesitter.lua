local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not ok then
	return
end

treesitter.setup {
	enure_installed = { 'bash', 'c', 'cpp', 'glsl', 'html', 'javascript', 'css', 'make', 'lua' },
	sync_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	},
	indent = { enable = true }
}

-- Create folds based on treesitter's ast
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 999
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*" },
    command = "normal zx",
})
