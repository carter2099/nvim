vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("i", "<C-c>", "<Esc>")
-- Type a word + c-s to create a tag
vim.keymap.set("i", "<C-s>", "<esc>yiwi<lt><esc>ea></><esc>hpF>a", { noremap = true })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>d", '"+d')
vim.keymap.set("n", "<leader>p", '"+p')

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
