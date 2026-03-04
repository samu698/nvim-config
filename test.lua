local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

---@param path string The file to open
---@param line integer The line where to center the preview
---@return number? bufnr The id of the preview buffer
local function load_preview(path, line)
    local lines = vim.fn.readfile(path)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    local ft = vim.filetype.match({ filename = path }) or ""
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].filetype = ft
    return bufnr
end

local function spawn_quickfix(files)
    local menu_items = {}
    local longest_line = 0
    for _, file in ipairs(files) do
        longest_line = math.max(longest_line, #file)
        local menu_item = Menu.item(file, { text = file })
        menu_items[#menu_items+1] = menu_item
    end

    local preview_popup = Popup({
        border = {
            style = "double",
            text = {
                top = menu_items[1].text,
                top_align = "right",
            },
        },
    })

    local menu_elem = Menu({
        border = {
            style = "single",
            text = {
                top = "Quickfix",
                top_align = "center"
            },
        },
    },
    {
        lines = menu_items,
        on_change = function(item, _)
            preview_popup.border:set_text("top", item.text, "right")

            -- Show preview
            vim.schedule(function()
                --local path = vim.uv.fs_realpath(item.text)
                local path = vim.fn.fnamemodify(item.text, ":p")
                local bufnr = load_preview(path, 0)
                if not bufnr then return end

                vim.api.nvim_win_set_buf(preview_popup.winid, bufnr)
                vim.wo[preview_popup.winid].number = true
            end)
        end,
    })


    local columns = vim.o.columns
    local layout_width = math.ceil(columns * 0.9)
    local menu_width = math.min(longest_line + 3, math.floor(layout_width * 0.25))
    local preview_width = layout_width - menu_width

    local layout = Layout({
        position = "50%",
        size = {
            width = layout_width,
            height = "80%",
        },
    }, {
        Layout.Box({
            Layout.Box(menu_elem, { size = menu_width }),
            Layout.Box(preview_popup, { size = preview_width }),
        }, { dir = "row", size = "100%" })
    })

    layout:mount()
end

spawn_quickfix({ "~/projects/aoc/d2/src/main.rs", "~/projects/aoc/d3/src/main.rs", "~/projects/aoc/d4/src/main.rs" })

