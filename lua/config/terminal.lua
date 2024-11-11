local M = {}

M.toggleterm = {
    open_mapping = require("config.mappings").terminal_open,
    autochdir = true,
    direction = 'float',
    float_opts = {
        border = 'curved'
    }
}

M.flatten = {
    window = {
        open = "current",
    },
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
}

return M
