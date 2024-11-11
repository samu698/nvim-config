local configs = {
    --mouse = '',
    updatetime = 1000,
    smartcase = true,
    swapfile = false,
    undofile = true,

    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    wrap = false,

    termguicolors = true,
    number = true,
    relativenumber = true,
    cursorline = true,
    background = "dark",
    scrolloff = 999,
    laststatus = 3,
    --cmdheight = 0,
    fillchars = "eob: ", -- Remove empty buffer lines char
}

for k, v in pairs(configs) do
    vim.opt[k] = v
end

-- Disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neovide config
if vim.g.neovide then
    vim.o.guifont = "FiraCode Nerd Font Mono:h12"
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    vim.g.neovide_scroll_animation_length = 0
end
