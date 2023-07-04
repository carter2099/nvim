local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "clangd",
    "cssls",
    "dockerls",
    "docker_compose_language_service",
    "eslint",
    "gradle_ls",
    "html",
    "jdtls",
    "jsonls",
    "tsserver",
    "lua_ls",
    "marksman",
    "pyre",
    "sqlls",
    "solidity",
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

lsp.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ["null-ls"] = { "javascript", "typescript", "lua" },
    },
})

lsp.setup()

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- Make sure the source name is supported by null-ls
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
    },
})
