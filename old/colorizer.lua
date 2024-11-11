function configure()
    require 'colorizer'.setup({
        '*';
        css = { names = true, rgb_fn = true, hsl_fn = true };
        html = { names = true, rgb_fn = true, hsl_fn = true }
    }, {
        RRGGBBAA = true,
        names = false,
    })
end

return {
    "norcalli/nvim-colorizer.lua",
    config = configure,
}
