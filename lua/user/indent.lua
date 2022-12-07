local ok1, indent = pcall(require, 'indent_blankline')
if not ok1 then
	return
end

vim.cmd 'highlight IndentBlanklineChar guifg=#383638'

indent.setup {
	char = '🭱',
	show_trailing_blankline_indent = false,
	show_current_context = true
}

local ok2, autoindent = pcall(require, 'autoIndent')
if not ok2 then
	return
end

autoindent.setup()
