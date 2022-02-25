" Create the `b:undo_ftplugin` variable if it doesn't exist
call ftplugined#check_undo_ft()

" Set-up LSP, linters, formatters
lua << EOF
local null_ls = require("null-ls")
null_ls.register({
    null_ls.builtins.diagnostics.shellcheck.with({
        -- Require explicit empty string test
        extra_args = { "-o", "avoid-nullary-conditions" },
    }),
    null_ls.builtins.formatting.shfmt.with({
        -- Indent with 4 spaces, simplify the code, indent switch cases, use POSIX
        extra_args = { "-i", "4", "-s", "-ci", "-ln", "posix" },
    }),
})
EOF