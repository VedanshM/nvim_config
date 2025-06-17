return {
    "tanvirtin/monokai.nvim",
    priority = 1000,
    init = function()
        vim.opt.background = "dark" -- set this to dark or light
        vim.cmd("colorscheme monokai_pro")
    end
}
