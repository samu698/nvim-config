local function map(keymaps)
    for key, opts in pairs(keymaps) do
        local mode = opts.mode or opts[1]
        local action = opts.act or opts[2]
        local desc = opts.desc or opts[3]
        local buffer = opts.buf or false
        vim.keymap.set(mode, key, action, { desc = desc, buffer = buffer })
    end
end

local M = {}

M.global_binds = function()
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"

    map({
        [";"] = { "n", ":", "Fast command mode" },
        ["n"] = { "n", "<C-r>", "Easier redo command" },
        ["<CR>"] = { "n", "<C-a>", "Easier increment command" },
        ["<BS>"] = { "n", "<C-x>", "Easier decrement command" },
        ["<C-w>"] = { "i", "<esc><C-w>", "Window switch in insert mode" },
        ["<Del>"] = { "t", "<C-\\><C-n>", "Enter normal mode from terminal" },
    })
end

M.lsp_binds = function()
    map({
        ["gd"] = { "n", vim.lsp.buf.definition, "Go to definition", buf = true },
        ["gD"] = { "n", vim.lsp.buf.declaration, "Go to declaration", buf = true },
        ["gi"] = { "n", vim.lsp.buf.implementation, "Go to implementation", buf = true },
        ["gT"] = { "n", vim.lsp.buf.type_definition, "Go to type definition", buf = true },
        ["gr"] = { "n", vim.lsp.buf.references, "Go to references", buf = true },
        ["g["] = { "n", vim.diagnostic.goto_next, "Go to next error", buf = true },
        ["g]"] = { "n", vim.diagnostic.goto_prev, "Go to previous error", buf = true },
        ["<leader>r"] = { "n", vim.lsp.buf.rename, "Rename symbol", buf = true },
        ["<leader>a"] = { "n", vim.lsp.buf.code_action, "Run code action", buf = true },
    })
end

M.complete_keymap = {
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },

    ["<Tab>"] = {
        function(cmp)
            if cmp.is_in_snippet() then return cmp.accept()
            else return cmp.select_and_accept() end
        end,
        "snippet_forward",
        "fallback"
    },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },

    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },

    ["<A-k>"] = { "scroll_documentation_up", "fallback" },
    ["<A-j>"] = { "scroll_documentation_down", "fallback" },
}

M.terminal_open = "<C-a>"

return M
