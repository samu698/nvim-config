return {
    {
        "f4z3r/gruvbox-material.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    {
        "norcalli/nvim-colorizer.lua",
        opts = {
            default = {
                RRGGBBAA = true,
                names = false,
            },
            files = {
                "*",
                "!toggleterm",
                css = { names = true, rgb_fn = true, hsl_fn = true },
                html = { names = true, rgb_fn = true, hsl_fn = true },
            },
        },
        config = function(_, opts)
            require("colorizer").setup(opts.files, opts.default)
        end,
    },

    {
        "akinsho/toggleterm.nvim",
        opts = {
            open_mapping = require("config.mappings").terminal_open,
            autochdir = true,
            direction = 'float',
            float_opts = {
                border = 'curved'
            }
        },
    },

    {
        "willothy/flatten.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            window = {
                open = "alternate",
            },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = require("config.lualine"),
    },

    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = require("config.bufferline"),
    },

    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "HiPhish/rainbow-delimiters.nvim" },
        build = ":TSUpdate",
        opts = require("config.treesitter").opts,
        config = require("config.treesitter").config,
    },

    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },

}
