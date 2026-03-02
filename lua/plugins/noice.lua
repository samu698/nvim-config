return {
    "folke/noice.nvim",
    dependencies = {
        {
            "MunifTanjim/nui.nvim",
            lazy = false,
        },
        "rcarriga/nvim-notify",
    },
    ---@type NoiceConfig
    opts = {
        messages = {
            view = "mini",
        },
        presets = {
            bottom_search = true,
            long_message_to_split = true,
        },
        redirect = {
            view = "notify",
        },
    },
    config = function(_, opts)
        local noice = require("noice")
        noice.setup(opts)
    end
}
