return {
    clangd = {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
        init_options = { fallbackFlags = { '-std=c++17' } },
    },
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                completion = {
                    callSnippet = "Replace",
                },
            },
        }
    },
    pyright = {},
    ruff = {},
    bashls = {},
}
