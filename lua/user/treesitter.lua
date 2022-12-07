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
