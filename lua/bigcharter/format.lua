-- This only works for blade templates
-- Define the function to format the file on save
_G.formatOnSave = function()
    local filename = vim.fn.expand("%")
    if filename:match("%.blade.php") then --and not string.find(filename, "%f[^.]*tests%.sol$") then
        vim.cmd("silent !prettier --write " .. vim.fn.shellescape(filename))
    end
end

-- Set up the autocommand to call the function
vim.cmd([[autocmd BufWritePost *.blade.php lua formatOnSave()]])
