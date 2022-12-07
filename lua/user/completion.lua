local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
	return
end
cmptypes = require('cmp.types')

local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
	return
end

-- vim.api.nvim_set_keymap('i', '<C-Right>', '<cmd>lua require("luasnip.extras.select_choice")()<cr>', {})
vim.api.nvim_set_keymap('i', '<C-Right>', '<cmd>lua vim.lsp.handlers.signature_help()<cr>', {})

local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},
	mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
		['<Down>'] = cmp.mapping({
			i = cmp.mapping.select_next_item({ behavior = cmptypes.cmp.SelectBehavior.Select }),
			c = function(fallback)
				cmp.close()
				vim.schedule(cmp.suspend())
				fallback()
			end
		}),
		['<Up>'] = cmp.mapping({
			i = cmp.mapping.select_prev_item({ behavior = cmptypes.cmp.SelectBehavior.Select }),
			c = function(fallback)
				cmp.close()
				vim.schedule(cmp.suspend())
				fallback()
			end
		}),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-e>'] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close()
		},
		['<CR>'] = cmp.mapping.confirm { select = true },
		['<Tab>'] = cmp.mapping(function(fallback)
				if luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				--elseif has_words_before() then
				--	cmp.complete()
				else
					fallback()
				end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' })
	},
	formatting = {
		fields = { 'kind', 'abbr', 'menu' },
		format = function(entry, vim_item)
			vim_item.kind = kind_icons[vim_item.kind]
			vim_item.menu = ({
				nvim_lsp = '[LSP]',
				luasnip = '[Snip]',
				buffer = '[Buffer]',
				path = '[Path]'
			})[entry.source.name]
			return vim_item
		end
	},
	sources = { 
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' }, 
		{ name = 'buffer' } 
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false
	},
	window = {
		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
		}
	},
	experimental = {
		ghost_text = false,
		native_menu = false
	}
}
