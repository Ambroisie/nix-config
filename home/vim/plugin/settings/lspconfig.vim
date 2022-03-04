lua << EOF
local lsp = require("lspconfig")
local utils = require("ambroisie.utils")

-- Inform servers we are able to do completion, snippets, etc...
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- C/C++
if utils.is_executable("clangd") then
    lsp.clangd.setup({
        capabilities = capabilities,
        on_attach = utils.on_attach,
    })
end

-- Nix
if utils.is_executable("rnix-lsp") then
    lsp.rnix.setup({
        capabilities = capabilities,
        on_attach = utils.on_attach,
    })
end

-- Python
if utils.is_executable("pyright") then
    lsp.pyright.setup({
        capabilities = capabilities,
        on_attach = utils.on_attach,
    })
end

-- Rust
if utils.is_executable("rust-analyzer") then
    lsp.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = utils.on_attach,
    })
end
EOF
