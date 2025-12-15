---@type LazySpec
return {
    "ahmedkhalf/project.nvim",
    main = "project_nvim",
    opts = {
        patterns = { ".git", "Cargo.toml", "Makefile" }
    }
}
