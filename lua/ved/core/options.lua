vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4       -- A TAB character looks like 4 spaces
opt.expandtab = true  -- Pressing the TAB key will insert spaces instead of a TAB character
opt.softtabstop = 4   -- Number of spaces inserted instead of a TAB character
opt.shiftwidth = 4    -- Number of spaces inserted when indenting
opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
---@diagnostic disable-next-line: param-type-mismatch
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
--fold expressions using treesitter
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Set the initial fold level when opening a file
opt.foldlevelstart = 99
-- Set the current fold level for the current buffer
opt.foldlevel = 99
opt.foldenable = false

local autocmd_utils = require("ved.utils.autocmds")
autocmd_utils.nvim_create_augroups({
    open_folds = {
        {
            "BufReadPost",
            {
                pattern = "*",
                callback = function()
                    vim.notify("Autocommand triggered: opening folds", vim.log.levels.INFO)
                    vim.cmd("normal! zR")
                end
            }
        }
    }
}
)

-- for ruff and pyright as suggested by gpt
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    severity_sort = true,
})
