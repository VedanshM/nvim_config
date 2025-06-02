-- local group = vim.api.nvim_create_augroup('autosave', {})
--
-- vim.api.nvim_create_autocmd('User', {
--     pattern = 'AutoSaveWritePost',
--     group = group,
--     callback = function(opts)
--         if opts.data.saved_buffer ~= nil then
--             local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
--             vim.notify('AutoSave: saved ' .. filename .. ' at ' .. vim.fn.strftime('%H:%M:%S'), vim.log.levels.INFO)
--         end
--     end,
-- })

return {
    "okuuva/auto-save.nvim",
    version = '^1.0.0',                       -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
    cmd = "ASToggle",                         -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
        debounce_delay = 1000
        -- your config goes here
        -- or just leave it empty :)
    },
}
