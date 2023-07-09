-- Define the function to format the file on save
_G.formatOnSave = function()
    local filename = vim.fn.expand("%")
    if filename:match("%.sol") then --and not string.find(filename, "%f[^.]*tests%.sol$") then
        vim.cmd("silent !prettier --write " .. vim.fn.shellescape(filename))
        --vim.cmd("e")
    end
end

-- Set up the autocommand for saving .sol files
vim.cmd([[autocmd BufWritePost *.sol lua formatOnSave()]])
