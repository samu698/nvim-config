local optsval = {
    keymap = {
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
    },
    nerd_font_variant = "mono",
    signature_help = {
        enabled = true,
    },
    fuzzy = {
        max_items = 100,
    },
    documentation = {
        auto_show = true,
        auto_show_delay_ms = 1000,
    },
}

local function configfn()
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
end

return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    opts = optsval,
    config = configfn,
}
