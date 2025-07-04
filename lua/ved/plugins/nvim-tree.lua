return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cmd = {
        'NvimTreeOpen',
        'NvimTreeClose',
        'NvimTreeToggle',
        'NvimTreeFocus',
        'NvimTreeRefresh',
        'NvimTreeFindFile',
        'NvimTreeFindFileToggle',
        'NvimTreeClipboard',
        'NvimTreeResize',
        'NvimTreeCollapse',
        'NvimTreeCollapseKeepBuffers',
        'NvimTreeHiTest',
      },
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
        { "<leader>ee", "<cmd>NvimTreeToggle<CR>",         desc = "Toggle file explorer" },                 -- toggle file explorer
        { "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer on current file" }, -- toggle file explorer on current file
        { "<leader>ec", "<cmd>NvimTreeCollapse<CR>",       desc = "Collapse file explorer" },               -- collapse file explorer
        { "<leader>er", "<cmd>NvimTreeRefresh<CR>",        desc = "Refresh file explorer" },                -- refresh file explorer
    },
    init = function()
        -- recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
        view = {
            width = 35,
            relativenumber = true,
        },
        -- change folder arrow icons
        renderer = {
            indent_markers = {
                enable = true,
            },
            icons = {
                glyphs = {
                    folder = {
                        arrow_closed = "", -- arrow when folder is closed
                        arrow_open = "", -- arrow when folder is open
                    },
                },
            },
          },
        -- disable window_picker for
        -- explorer to work well with
        -- window splits
        actions = {
            open_file = {
                window_picker = {
                    enable = false,
                },
            },
          },
        filters = {
            custom = { ".DS_Store" },
        },
        git = {
            ignore = false,
        },
        update_focused_file = { enable = true }
    },
}
