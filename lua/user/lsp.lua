local lsp_ok, lspconfig = pcall(require, 'lspconfig')
if not lsp_ok then
	return
end

local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	client.server_capabilities.semanticTokensProvider = nil

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

lspconfig.clangd.setup {
	on_attach = on_attach,
	cmd = {
		'clangd',
		'--background-index',
		'-j=2',
		'--all-scopes-completion',
		'--completion-style=detailed',
		'--limit-results=50',
		'--suggest-missing-includes',
		'--header-insertion=never'
	},
	filetypes = { "c", "cpp" },
	init_option = { fallbackFlags = { "-std=c++20" } },
	capabilities = capabilities
}

lspconfig.rust_analyzer.setup {
	on_attach = on_attach,
	cmd = {
		'rust-analyzer',
		'-v',
		'-v',
		'--log-file',
		'/home/samu698/projects/lsp.log'
	},
	capabilities = capabilities
}

lspconfig.pylsp.setup {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = {'W391'},
					maxLineLength = 120
				}
			}
		}
	}
}

local default_servers = { 'gopls', 'asm_lsp', 'fsautocomplete' }
for _, lsp in ipairs(default_servers) do
	lspconfig[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end
