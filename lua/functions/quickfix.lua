local M = {}

-- Function to replace the quickfix window, using a nui.nvim menu instead

---@param elements vim.lsp.LocationOpts.OnList
function M.on_list(elements)
    local menu = require("nui.menu")

    ---@type NuiTree.Node[]
    local lines = {}
    for _, item in ipairs(elements.items) do
        local line = menu.item(item.text, item)
        lines[#lines+1] = line
        -- TODO: use better method for slicing
        if #lines > 100 then break end
    end

    ---@type nui_popup_options
    local popup_options = {
        relative = "cursor",
        position = {
            row = 1,
            col = 0,
        },
        border = {
            style = "rounded",
            text = {
                -- TODO: show this based on the action
                top = "[Quickfix]",
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal",
        },
    }

    ---@type nui_menu_options
    local options = {
        lines = lines,
        max_width = 50,
        max_height = 15,
        keymap = {
            -- TODO: make this configurable
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "<Esc>", "<C-c>" },
            submit = { "<CR>", "<Space>" },
        },
        on_submit = function(item)
            vim.print(item)
        end,
    }

    local el = menu(popup_options, options)
    el:mount()
end

return M
