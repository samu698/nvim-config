local fn = {}

local Popup = require("nui.popup")
local ns = vim.api.nvim_create_namespace("ui_preview")

---@class Preview.show_item_opts
---@field text string? The text to show in the border
---@field full_open boolean?

---@class Preview.bufinfo
---@field id integer
---@field full boolean

---@class Preview: NuiPopup
---@field private buffers table<string, Preview.bufinfo>
---@field private current_buf integer?
---@field private to_show { item: Quickfix.item, bufnr: integer }?
---@field private should_enter boolean?
---@diagnostic disable-next-line: undefined-field
local Preview = Popup:extend("Preview")

--- Create a preview window
--- @param opts nui_popup_options
function Preview:init(opts)
    ---@diagnostic disable-next-line: undefined-field
    Preview.super.init(self, opts)

    self.buffers = {}
    -- FIXME: make sure to create the border text
end

--- Show an item in the preview
---@param item Quickfix.item The item to show
---@param opts Preview.show_item_opts
function Preview:show_item(item, opts)
    local bufnr = self:get_or_open_buffer(item.path, opts.full_open or false)
    local text = opts.text or item.path
    -- Set the border text
    self.border:set_text("top", text, "right")

    if not self.winid then
        -- Schedule the items to be showed, if the window is not displayed
        self.to_show = { item = item, bufnr = bufnr }
    else
        -- Show the new buffer on the window
        self:update_window(item, bufnr)
    end
end

---@param item Quickfix.item
---@param bufnr integer
---@private
function Preview:update_window(item, bufnr)
    if bufnr ~= self.current_buf then
        if self.current_buf then
            vim.api.nvim_buf_clear_namespace(self.current_buf, ns, 0, -1)
        end

        vim.api.nvim_win_set_buf(self.winid, bufnr)
        vim.wo[self.winid].number = true
        self.current_buf = bufnr
    end

    -- Move the currsor to the correct line and highlight it
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    if item.pos then
        vim.api.nvim_win_set_cursor(self.winid, item.pos)

        -- TODO: for now we highlight only the current line
        local line = item.pos[1]
        vim.hl.range(bufnr, ns, "Search", { line - 1, 0 }, { line - 1, -1 })
    end
end

function Preview:_open_window()
    ---@diagnostic disable-next-line: undefined-field
    Preview.super._open_window(self)

    if self.to_show then
        self:update_window(self.to_show.item, self.to_show.bufnr)
        self.to_show = nil
    end

    if self.should_enter then
        self:_enter()
        self.should_enter = false
    end
end

--- Move the cursor to this window
function Preview:enter()
    if self.winid then self:_enter() end
    self.should_enter = true
end

--- Moves the cursor to the window without waiting
---@private
function Preview:_enter()
    assert(self.winid)
    vim.api.nvim_set_current_win(self.winid)
end

--- Removes loaded buffers from the cache, except the currenty shown one
function Preview:clear_buffers()
    if not self.buffers then return end

    local current_path = nil
    local current_bufinfo = nil
    for path, bufinfo in pairs(self.buffers) do
        if bufinfo.id ~= self.current_buf then
            vim.api.nvim_buf_delete(bufinfo.id, {})
        else
            current_path = path
            current_bufinfo = bufinfo
        end
    end

    if current_path and current_bufinfo then
        self.buffers = { [current_path] = current_bufinfo }
    end
end

function Preview:unmount()
    ---@diagnostic disable-next-line: undefined-field
    Preview.super.unmount(self)

    if self.current_buf then
        vim.api.nvim_buf_clear_namespace(self.current_buf, ns, 0, -1)
        self.current_buf = nil
    end
    Preview:clear_buffers()
end

---@param path string The path of the buffer to open
---@param full boolean Whether it is a full buffer
---@return integer bufnr
---@private
function Preview:get_or_open_buffer(path, full)
    local bufinfo = self.buffers[path] ---@type Preview.bufinfo?
    if bufinfo and (not full or bufinfo.full) then
        return bufinfo.id
    end

    -- Use an existing buffer if it is present
    local existing = vim.fn.bufnr(path)
    if existing ~= -1 then
        return existing
    end

    if full then
        if bufinfo then vim.api.nvim_buf_delete(bufinfo.id, {}) end
        bufinfo = fn.load_buffer_full(path)
    else
        bufinfo = fn.load_buffer_lines(path)
    end

    self.buffers[path] = bufinfo
    return bufinfo.id
end

--- Create a preview buffer by copying the lines of the file
---@param path string
---@return Preview.bufinfo bufinfo
function fn.load_buffer_lines(path)
    -- TODO: Error checking
    local lines = vim.fn.readfile(path)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    local ft = vim.filetype.match({ filename = path }) or ""
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].filetype = ft

    return {
        id = bufnr,
        full = false,
    }
end

--- Open a preview buffer by fully loading the file
---@param path string
---@return Preview.bufinfo bufinfo
function fn.load_buffer_full(path)
    local bufnr = vim.fn.bufadd(path)
    vim.fn.bufload(bufnr)
    vim.bo[bufnr].modifiable = false

    return {
        id = bufnr,
        full = true,
    }
end

---@alias Preview.constructor fun(opts: nui_popup_options): Preview
---@type Preview|Preview.constructor
local CtorPreview = Preview

return CtorPreview
