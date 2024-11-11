local M = {}

M.toggleterm = {
    open_mapping = require("config.mappings").terminal_open,
    autochdir = true,
    direction = 'float',
    float_opts = {
        border = 'curved'
    }
}

local saved_terminal

M.flatten = {
    window = {
        open = "current",
    },
    callbacks = {
        pre_open = function()
            local term = require("toggleterm.terminal")
            local termid = term.get_focused_id()
            saved_terminal = term.get(termid);
        end,
        post_open = function(bufnr, winnr, ft, is_blocking)
            if ft == "gitcommit" or ft == "gitrebase" then
                vim.api.nvim_create_autocmd("BufWritePost", {
                    buffer = bufnr,
                    once = true,
                    callback = vim.schedule_wrap(function()
                        vim.api.nvim_buf_delete(bufnr, {})
                    end)
                })
            end
        end,
        block_end = vim.schedule_wrap(function()
            if saved_terminal then
                saved_terminal:open()
                saved_terminal = nil
            end
        end),
    },
}

return M
