return {
    "neovim/nvim-lspconfig",
    version = "^v1.8.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} },
        "joechrisellis/lsp-format-modifications.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")


        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                -- set keybinds
                local keymap = vim.keymap
                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = "Show LSP definitions"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, opts) -- jump to previous diagnostic in buffer

                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, opts) -- jump to next diagnostic in buffer

                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
            end,
        })
        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()
        capabilities.general = capabilities.general or {}
        capabilities.general.positionEncodings = { "utf-16" } --  Force all clients to use UTF-8

        -- Change the Diagnostic symbols in the sign column (gutter)
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = ' ',
                    [vim.diagnostic.severity.WARN] = ' ',
                    [vim.diagnostic.severity.INFO] = '󰠠 ',
                    [vim.diagnostic.severity.HINT] = ' ',
                }
            }
        })
        local on_attach = function(client, bufnr)
            local augroup_id = vim.api.nvim_create_augroup(
                "FormatModificationsDocumentFormattingGroup",
                { clear = false }
            )
            local filetype = vim.bo[bufnr].filetype
            -- Disable LSP formatting for Python
            if filetype == "python" then
                client.server_capabilities.documentFormattingProvider = false
            end
            if client.name == "ruff" then
                client.server_capabilities.hoverProvider = false
                client.server_capabilities.definitionProvider = false
            end

            vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = bufnr })
            vim.api.nvim_create_autocmd(
                { "BufWritePre" },
                {
                    group = augroup_id,
                    buffer = bufnr,
                    callback = function()
                        local result = { success = false }
                        if filetype ~= "python" then
                            result = lsp_format_modifications.format_modifications(client, bufnr)
                        end
                        if not result.success then -- fall back to full-document formatting
                            vim.notify("formating using conform", vim.log.levels.DEBUG)
                            -- vim.lsp.buf.format { id = client.id, bufnr = bufnr }
                            require("conform").format({
                                bufnr = bufnr,
                                async = true,
                                stop_after_first = true,
                                lsp_format = "fallback",
                                id = client.id,
                            })
                        else
                            vim.notify("formating using lsp_format_modifications", vim.log.levels.DEBUG)
                        end
                    end,
                }
            )
        end

        mason_lspconfig.setup_handlers({
            -- default handler for installed servers
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,
            ["clangd"] = function()
                lspconfig["clangd"].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
                    init_options = {
                        fallbackFlags = { '-std=c++17' },
                    }
                })
            end,
            ["lua_ls"] = function()
                -- configure lua server (with special settings)
                lspconfig["lua_ls"].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = {
                        Lua = {
                            -- make the language server recognize "vim" global
                            diagnostics = {
                                globals = { "vim" },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                })
            end,
        })
    end,
}
