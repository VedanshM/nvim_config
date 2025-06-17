return {
    { "hrsh7th/cmp-nvim-lsp",                        lazy = true, opts = {} },
    { "joechrisellis/lsp-format-modifications.nvim", lazy = true, },
    {
        -- allow LSP to do file ops
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        opts = {},
        lazy = true,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
