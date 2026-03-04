local M = {}

---@diagnostic disable: unused-function

-- Function to replace the quickfix window, using a nui.nvim menu instead

--[[
        bufnr	buffer number; must be the number of a valid
            buffer
        filename	name of a file; only used when "bufnr" is not
            present or it is invalid.
        module	name of a module; if given it will be used in
            quickfix error window instead of the filename.
        lnum	line number in the file
        end_lnum	end of lines, if the item spans multiple lines
        pattern	search pattern used to locate the error
        col		column number
        vcol	when non-zero: "col" is visual column
            when zero: "col" is byte index
        end_col	end column, if the item spans multiple columns
        nr		error number
        text	description of the error
        type	single-character error type, 'E', 'W', etc.
        valid	recognized error message
        user_data
            custom data associated with the item, can be
            any type.
--]]

-- Implementation:
-- Users call open quickfix
--  -> the quickfix opens
--  -> the previous quickfix gets deleted (TODO: quickfix nesting)
--  -> actions get handled by 

---@class Quickfix
---@field preview_buffers table<string, integer>
---@field ui Quickfix.ui
---
---@class Quickfix.ui
---@field menu NuiMenu
---@field preview NuiPopup
---@field outer NuiLayout

---@class Quickfix.item
---@field text string Short description of the quickfix item
---@field path string The path where to find the quickfix location
---@field pos Quickfix.item.pos?
---
---@class Quickfix.item.pos
---@field line number
---@field col number?

---@type Quickfix?
local quickfix = nil

---@param text string
---@param align nui_t_text_align
---@return nui_popup_options
local function popup_config(text, align)
    return {
        border = {
            style = "single",
            text = {
                top = text,
                top_align = align,
            },
        }
    }
end

--- Load a file preview buffer
---@param path string
---@return integer? bufnr
local function load_preview(path)
    -- TODO: Error checking
    local lines = vim.fn.readfile(path)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    local ft = vim.filetype.match({ filename = path }) or ""
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].filetype = ft
    return bufnr
end

--- Remove the currently open quickfix
local function close()
    -- TODO
end

---@param item NuiTree.Node
local function on_change(item, _)
    ---@cast item +Quickfix.item
    if not quickfix then return end

    ---@type integer?
    local bufnr = quickfix.preview_buffers[item.path]
    if not bufnr then
        bufnr = load_preview(item.path)
        if not bufnr then return end
        quickfix.preview_buffers[item.path] = bufnr
    end

    local preview = quickfix.ui.preview
    preview.border:set_text("top", item.text, "right")
    vim.api.nvim_win_set_buf(preview.winid, bufnr)
    if item.pos then
        local line = item.pos.line
        local col = item.pos.col or 0
        vim.api.nvim_win_set_cursor(preview.winid, { line, col } )
    end
    vim.wo[preview.winid].number = true
end

---@param item NuiTree.Node
local function on_submit(item)
    ---@cast item +Quickfix.item
    if not quickfix then return end
    -- TODO
end

--- Generate the UI for the quickfix window
---@param title string The title to give to the quickfix
---@param items Quickfix.item[] list of items to show in the quickfix
---@return Quickfix.ui
local function make_ui(title, items)
    local Layout = require("nui.layout")
    local Menu = require("nui.menu")
    local Popup = require("nui.popup")

    local menu_items = {}
    local longest_line = 0
    for _, item in ipairs(items) do
        longest_line = math.max(longest_line, #item.text)
        local menu_item = Menu.item(item.text, item)
        menu_items[#menu_items+1] = menu_item
    end

    local menu = Menu(
        popup_config(title, "center"),
        {
            lines = menu_items,
            -- TODO: try to remove schedule_wrap
            -- This is _probably_ needed because the preview window is not 
            -- present when on_change is called
            on_change = vim.schedule_wrap(on_change),
            on_submit = vim.schedule_wrap(on_submit),
        }
    )
    local preview = Popup(popup_config("", "right"))

    local columns = vim.o.columns
    local layout_width = math.ceil(columns * 0.9)
    local menu_width = math.min(longest_line + 3, math.floor(layout_width * 0.25))
    local preview_width = layout_width - menu_width
    local outer = Layout({
        position = "50%",
        size = {
            width = layout_width,
            height = "80%",
        },
    }, {
        Layout.Box({
            Layout.Box(menu, { size = menu_width }),
            Layout.Box(preview, { size = preview_width }),
        }, { dir = "row", size = "100%" })
    })

    return {
        menu = menu,
        preview = preview,
        outer = outer,
    }
end

--- Open a new quickfix
---@param title string The title to give to the quickfix
---@param items Quickfix.item[] list of items to show in the quickfix
function M.open(title, items)
    if quickfix then close() end
    quickfix = {
        preview_buffers = {},
        ui = make_ui(title, items),
    }

    quickfix.ui.outer:mount()
end

---@param entires vim.quickfix.entry[]
---@return Quickfix.item[] itmes
function M.conv_setqflist_what(entires)
    local items = {}
    for _, entry in ipairs(entires) do
        -- TODO: improve this
        if not entry.text then goto continue end
        if not entry.filename then goto continue end

        ---@type Quickfix.item
        local item = {
            text = entry.text,
            path = entry.filename,
        }

        if entry.lnum then
            item.pos = {
                line = entry.lnum,
                col = entry.col,
            }
        end

        items[#items+1] = item

        ::continue::
    end
    return items
end

---@return vim.lsp.ListOpts
function M.list_opts()
    ---@type vim.lsp.ListOpts
    local opts = {
        on_list = function(t)
            local items = M.conv_setqflist_what(t.items)
            local title = t.title or "[Quickfix]"
            M.open(title, items)
        end
    }
    return opts
end

return M
