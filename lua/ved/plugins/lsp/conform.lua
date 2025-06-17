return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = require("ved.config.formatters"),
        format_on_save = false, -- we handle formatting in our custom on_attach
    },
}
