local M = {}

-- Function to replace the quickfix window, using a nui.nvim menu instead


-- Follows a quickfix entry
---@param item vim.quickfix.entry
---@param reuse boolean whether to reuse open windows
---@return integer|nil bufnr
---@diagnostic disable: unused-function
local function follow_entry(item, reuse)
    local bufnr = item.bufnr
    if not bufnr or bufnr == 0 then
        if not item.filename then return end
        bufnr = vim.fn.bufadd(item.filename)
    end

end

---@param title string the title of the quickfix
local function make_on_list(title)
    ----@param elements vim.lsp.LocationOpts.OnList
    return function(elements)
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
                    top = title,
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
                ---@diagnostic disable-next-line: assign-type-mismatch
                vim.fn.setqflist({}, " ", { items = { item } })
                vim.cmd.cfirst()
            end,
        }

        local el = menu(popup_options, options)
        el:mount()
    end
end

---@param title string the title for the quickfix
---@return vim.lsp.ListOpts
function M.list_opts(title)
    return { on_list = make_on_list(title) }
end

return M
