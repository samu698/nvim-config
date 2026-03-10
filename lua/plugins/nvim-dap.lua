local map = require("utils").map

local function ignore_dap_opened_buffers()
    local dap = require("dap")

    local ignore_buffers = false
    dap.listeners.before.event_stopped["ignore_bufs"] = function()
        ignore_buffers = true
    end

    dap.listeners.after.event_stopped["ignore_bufs"] = function()
        vim.defer_fn(function() ignore_buffers = false end, 50)
    end

    vim.api.nvim_create_autocmd("BufAdd", {
        callback = function(args)
            if ignore_buffers then
                vim.bo[args.buf].buflisted = false
            end
        end
    })
end

---@type LazySpec
return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "jbyuki/one-small-step-for-vimkind",
        {
            "igorlfs/nvim-dap-view",
            ---@module 'dap-view'
            ---@type dapview.Config
            opts = {
                winbar = {
                    sections = {
                        "scopes", "watches",
                        "breakpoints", "threads",
                    },
                    default_section = "scopes",
                    show_keymap_hints = false,
                    base_sections = {
                        scopes = { label = "Vars", keymap = "V" },
                        watches = { label = "Watch" },
                        breakpoints = { label = "Break" },
                        threads = { label = "Thread" },
                    },
                    controls = {
                        enabled = true,
                        buttons = {
                            "step_over", "step_into",
                            "step_over", "step_out",
                            "play", "terminate",
                            "disconnect",
                        }
                    },
                },
                windows = {
                    size = 0.3,
                    position = "right",
                },
                auto_toggle = true,
                follow_tab = true,
            }
        },
    },
    config = function (_, _)
        local dap = require("dap")

        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
            },
        }

        dap.adapters.nlua = function(callback, config, _)
            local host = config.host or "127.0.0.1"
            local port = config.port or 8086
            callback({ type = "server", host = host, port = port })
        end

        ignore_dap_opened_buffers()

        map.load("dap")
    end,
}
