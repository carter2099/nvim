-- Bootstrap lazy.nvim at a reviewed immutable revision.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
local lazyrev = "306a05526ada86a7b30af95c5cc81ffba93fef97"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local clone_out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--no-checkout", lazyrepo, lazypath,
    })
    local checkout_out = ""
    if vim.v.shell_error == 0 then
        checkout_out = vim.fn.system({
            "git", "-C", lazypath, "checkout", "--detach", lazyrev,
        })
    end
    if vim.v.shell_error ~= 0 then
        vim.fn.delete(lazypath, "rf")
        vim.api.nvim_echo({
            { "Failed to install pinned lazy.nvim:\n", "ErrorMsg" },
            { clone_out .. checkout_out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    checker = { enabled = true },

})
