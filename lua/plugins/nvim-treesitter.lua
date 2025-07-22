return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = { "lua", "ruby", "go", "json", "yaml", "markdown", "c_sharp" },
            sync_install = false,
            highlight = { enable = true },
        })
    end
}
