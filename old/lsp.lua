local optsval = {
    server_configs = {
        rust_analyzer = {},
        lua_ls = {},
        clangd = {
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
            filetypes = { "c", "cpp", "h", "hpp" },
        },
    },
}

function configfn(_, opts)
    local lspconfig = require("lspconfig")

    local on_attach = function()
        local bufmap = function(mode, keys, mapping)
            vim.keymap.set(mode, keys, mapping, { buffer = true })
        end

        bufmap("n", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>")
        bufmap("n", "gD", "<CMD>lua vim.lsp.buf.declaration()<CR>")
        bufmap("n", "gi", "<CMD>lua vim.lsp.buf.implementation()<CR>")
        bufmap("n", "gT", "<CMD>lua vim.lsp.buf.type_definition()<CR>")
        bufmap("n", "gr", "<CMD>lua vim.lsp.buf.references()<CR>")
        bufmap("n", "<leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>")
        bufmap("n", "<leader>a", "<CMD>lua vim.lsp.buf.code_action()<CR>")
        bufmap("n", "g[", "<CMD>lua vim.diagnostic.goto_next()<CR>")
        bufmap("n", "g]", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
    end

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    for lsp, lspopts in pairs(opts.server_configs) do
        local default = {
            on_attach = on_attach,
            capabilities = capabilities,
        }
        local config = vim.tbl_deep_extend("force", default, lspopts)
        lspconfig[lsp].setup(config)
    end
end

return {
    "neovim/nvim-lspconfig",
    dependencies = "saghen/blink.cmp",
    opts = optsval,
    config = configfn,
}
