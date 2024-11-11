local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = "", warn = "" }
}

local filename = {
    "filename",
    newfile_status = true,
    symbols = {
        modified = "",
        readonly = "",
        unnamed = "",
        newfile = "",
    },
}

local function location()
    return 'L%l'
end

return {
    options = {
        icons_enabled = true,
        theme = 'gruvbox-material',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''}
    },
    sections = {
        lualine_a = { filename },
        lualine_b = { diagnostics },
        lualine_c = { },

        lualine_x = { location },
        lualine_y = { "filetype" },
        lualine_z = { "branch" },
    },
}
