return {
    'rmagatti/auto-session',
    lazy = false,
    init = function()
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {
        auto_save = true,
        root_dir = vim.fn.stdpath "state" .. "/sessions/",
        --git_use_branch_name = true,
        --git_auto_restore_on_branch_change = true,
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        -- log_level = 'debug',
    },
}
