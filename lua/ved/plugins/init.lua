return {
    "HiPhish/rainbow-delimiters.nvim",
    "folke/zen-mode.nvim",
    {
        "princejoogie/dir-telescope.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        opts = {},
        keys = {
            { "<leader>fdf", "<cmd>FileInDirectory<cr>", desc = "Find File in Directory" },
            { "<leader>fds", "<cmd>GrepInDirectory<cr>", desc = "Search String in Directory" },
        },
    },
    {
        "nhu/patchr.nvim",
        opts = {
            plugins = {
                ["lsp-format-modifications.nvim"] = {
                    vim.fn.stdpath("config") .. "/lua/ved/patches/lsp-format-modifications_async.patch",
                },
            },
        },
    }
}
