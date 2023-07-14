require("rose-pine").setup({
    disable_background = true,
    groups = {
        comment = "subtle",
        punctuation = "text",
    },
    highlight_groups = {
        Operator = { fg = "text" },
    },
    --comment
})

function FixBg(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

FixBg()
