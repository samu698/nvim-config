local M = {}

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

---@class Quickfix.pos
---@field line number
---@field col number?

---@class Quickfix.item
---@field text string Short description of the quickfix item
---@field path string The path where to find the quickfix location
---@field pos Quickfix.pos?

---@class Quickfix
---@field preview_buffers integer[]
---@field menu_win NuiMenu
---@field preview_win NuiPopup
---@field outer_win NuiLayout
local Quickfix = {}

---@type Quickfix?
local instance = nil

---@param items Quickfix.item[]
---@param title string Title for the quickfix
---@return Quickfix
function Quickfix:new(items, title)
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

    local menu_win = Menu({
        border = {
            style = "single",
            text = {
                top = title,
                top_align = "right",
            },
        },
    }, {
        lines = menu_items,
    })

    local preview_win = Popup({
        border = {
            style = "single",
            text = {
                top = items[1].text,
                top_align = "right",
            },
        },
    })

    local columns = vim.o.columns
    local layout_width = math.ceil(columns * 0.9)
    local menu_width = math.min(longest_line + 3, math.floor(layout_width * 0.25))
    local preview_width = layout_width - menu_width

    local outer_win = Layout({
        position = "50%",
        size = {
            width = layout_width,
            height = "80%",
        },
    }, {
        Layout.Box({
            Layout.Box(menu_win, { size = menu_width }),
            Layout.Box(preview_win, { size = preview_width }),
        }, { dir = "row", size = "100%" })
    })

    ---@type Quickfix
    local inst = {
        preview_buffers = {},
        menu_win = menu_win,
        preview_win = preview_win,
        outer_win = outer_win,
    }

    setmetatable(inst, { __index = self })
    instance = inst
    return inst
end

function Quickfix:mount()
end
