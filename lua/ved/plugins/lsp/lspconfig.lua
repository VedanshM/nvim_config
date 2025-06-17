return {
    -- used for having sane defaults while configuring LSPs
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
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
        local lsp_format_modifications = require("lsp-format-modifications")
        local custom_formatters = require("ved.config.formatters")
        local on_attach = function(client, bufnr)
            local filetype = vim.bo[bufnr].filetype
            -- Disable LSP formatting for filetypes with custom_formatters
            if custom_formatters[filetype] then
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end
            if filetype == "python" then
                if client.name == "ruff" then
                    client.server_capabilities.hoverProvider = false
                    client.server_capabilities.definitionProvider = false
                else
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    return
                end
            end
            local augroup_id = vim.api.nvim_create_augroup(
                "FormatModificationsDocumentFormattingGroup",
                { clear = false }
            )
            vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = bufnr })
            vim.api.nvim_create_autocmd(
                { "BufWritePre" },
                {
                    group = augroup_id,
                    buffer = bufnr,
                    callback = function()
                        local result = { success = false }
                        if client.server_capabilities.documentRangeFormattingProvider then
                            result = lsp_format_modifications.format_modifications(client, bufnr, { async = true })
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

        local lspconfig = require("lspconfig")
        local servers = require("ved.config.servers")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.general = capabilities.general or {}
        capabilities.general.positionEncodings = { "utf-16" } --  Force all clients to use UTF-16

        for name, opts in pairs(servers) do
            lspconfig[name].setup(vim.tbl_deep_extend("force", {
                on_attach = on_attach,
                capabilities = capabilities
            }, opts))
        end
    end,
}
