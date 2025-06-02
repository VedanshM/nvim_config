local api = vim.api
local M = {}

function M.nvim_create_augroups(definitions)
    for group_name, defs in pairs(definitions) do
        local group_id = api.nvim_create_augroup(group_name, { clear = true })
        for _, def in ipairs(defs) do
            local event = def[1]
            local opts = def[2]
            opts.group = group_id
            api.nvim_create_autocmd(event, opts)
        end
    end
end

return M
