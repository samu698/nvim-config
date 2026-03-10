local M = {}
-- Function to replace the quickfix window, using a nui.nvim menu instead

local Preview = require("functions.preview")
local Menu = require("nui.menu")
local Layout = require("nui.layout")
local event = require("nui.utils.autocmd").event

---@class Quickfix.item
---@field text string Short description of the quickfix item
---@field path string The path where to find the quickfix location
---@field pos ({ [1]: integer, [2]: integer })? Position of the item

---@type NuiMenu?
local menu = nil

---@type Preview?
local preview = nil

---@type NuiLayout?
local layout = nil

---Opens a new quickfix
---@param title string
---@param items Quickfix.item[]
function M.open(title, items)
    if layout then M.close() end
    if #items == 0 then return end

    local show_item = nil
    if #items == 1 then
        show_item = items[1]

        local bufnr = vim.fn.bufnr(show_item.path)
        local winid = (bufnr == -1) and -1 or vim.fn.bufwinid(bufnr)
        if winid ~= -1 then
            vim.api.nvim_set_current_win(winid)
            if show_item.pos then
                vim.api.nvim_win_set_cursor(winid, show_item.pos)
            end
            return
        end
    end

    if not show_item then
        M.create_menu(title, items)
    end

    M.create_ui(show_item)
    M.update_layout()

    assert(layout)
    layout:mount()
end

---Opens a new quickfix, uses qflist entries as input
---@param title string
---@param entires Quickfix.item[]
function M.open_qflist(title, entires)
    entires = M.conv_qlist_entries(entires)
    M.open(title, entires)
end

---Closes the currently open quickfix
function M.close()
    if layout then
        layout:unmount()
    end

    menu = nil
    preview = nil
    layout = nil
end

---@private
---@param item Quickfix.item? The item to show in the preview
function M.create_ui(item)
    ---@type Preview
    preview = Preview(M.popup_opts("", "right"))

    if item then
        preview:show_item(item, { full_open = true })
    end

    ---@type nui_layout_options
    local layout_opts = {
        relative = "editor",
        position = "50%",
        size = {
            width = "90%",
            height = "80%",
        },
    }

    local box = Layout.Box({
        Layout.Box(preview, { size = "100%" }),
    }, { dir = "row", size = "100%" })

    layout = Layout(layout_opts, box)
end

---@private
function M.update_layout()
    if not layout then return end
    assert(preview)

    local box
    if menu then
        box = Layout.Box({
            Layout.Box(menu, { size = "20%" }),
            Layout.Box(preview, { size = "80%" }),
        }, { dir = "row", size = "100%" })
    else
        box = Layout.Box({
            Layout.Box(preview, { size = "100%" }),
        }, { dir = "row", size = "100%" })

        preview:on(event.WinLeave, function()
            vim.print("Event")
            preview:unmount()
        end)
        preview:enter()
    end

    layout:update(box)
end

---Create the menu component
---@param title string
---@param items Quickfix.item[]
---@private
function M.create_menu(title, items)
    local lines = {}
    for _, item in pairs(items) do
        lines[#lines+1] = Menu.item(item.text, item)
    end

    local popup_opts = M.popup_opts(title, "center")

    ---@type nui_menu_options
    local menu_opts = {
        lines = lines,
        on_change = M.on_change,
        on_submit = M.on_submit,
        on_close = M.close,
    }

    menu = Menu(popup_opts, menu_opts)
end

---@param item Quickfix.item
---@param _ NuiMenu
---@private
function M.on_change(item, _)
    if not preview then return end
    preview:show_item(item, {})
end

---@param item Quickfix.item
---@private
function M.on_submit(item)
    if not preview then return end
    if not menu then return end

    menu:unmount()
    preview:show_item(item, { full_open = true })
    M.update_layout()
end

---@param text string
---@param align nui_t_text_align
---@return nui_popup_options
---@private
function M.popup_opts(text, align)
    ---@type nui_popup_options
    local opts = {
        border = {
            style = "rounded",
            text = {
                top = text,
                top_align = align,
            },
        },
    }
    return opts
end

---@param entires vim.quickfix.entry[]
---@return Quickfix.item[] itmes
---@private
function M.conv_qlist_entries(entires)
    local items = {}
    for _, entry in ipairs(entires) do
        -- TODO: improve this
        if not entry.text then goto continue end
        if not entry.filename then goto continue end

        local pos = nil
        if entry.lnum then
            pos = { entry.lnum, entry.col or 0 }
        end

        ---@type Quickfix.item
        local item = {
            text = entry.text:match("^%s*(.-)%s*$"),
            path = entry.filename,
            pos = pos
        }

        items[#items+1] = item

        ::continue::
    end
    return items
end

return M
