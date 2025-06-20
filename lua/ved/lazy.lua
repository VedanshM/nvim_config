local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        { import = "ved.plugins" },
        { import = "ved.plugins.lsp" },
    },
    {
        checker = {
            enabled = true,
            notify = false,
            frequency = 43200,
        },
        change_detection = {
            enabled = true,
            notify = false,
        },
    }
)
