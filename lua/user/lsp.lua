local lsp_ok, lspconfig = pcall(require, 'lspconfig')
if not lsp_ok then
	return
end

local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	local keymap = function(mode, key, action, in_opts)
		vim.api.nvim_buf_set_keymap(bufnr, mode, key, action, in_opts)
	end

	keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declarations()<CR>', opts)
	keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	keymap('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {silent = true})
	keymap('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>', {silent = true})
    keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

	vim.api.nvim_exec([[
    augroup lsp_document_highlight
    	autocmd! * <buffer>
    	autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    	autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
	]], false)
end

local cmp_ok, cmplsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_ok then
	return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmplsp.default_capabilities(capabilities)

local servers = { 'clangd', 'rust_analyzer', 'gopls' }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end
