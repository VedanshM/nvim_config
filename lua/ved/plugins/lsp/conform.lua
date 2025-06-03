return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            python = { "black" },
        },
        format_on_save = false, -- we handle formatting in our custom on_attach
    },
}
