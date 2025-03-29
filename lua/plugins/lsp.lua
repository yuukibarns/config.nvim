return {

    -- cmdline tools and lsp servers
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = { ui = { border = "rounded", height = 0.8 } },
    },

    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = { "mason.nvim" },
        config = function()
            -- diagnostic keymaps
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Loclist Diagnostics" })

            -- diagnostics config
            vim.diagnostic.config({
                virtual_lines = { current_line = true },
                severity_sort = true,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client == nil then
                        return
                    end
                    if client.name == "ruff" then
                        -- Disable hover in favor of Pyright
                        client.server_capabilities.hoverProvider = false
                    end
                end,
                desc = "LSP: Disable hover capability from Ruff",
            })

            -- lspconfig
            -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            local settings = {
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        completion = { callSnippet = "Replace" },
                    },
                },
                texlab = {
                    texlab = {
                        build = {
                            forwardSearchAfter = false,
                            executable = "/usr/bin/pdflatex",
                            args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
                            onSave = false,
                        },
                        forwardSearch = {
                            executable = "/bin/okular",
                            args = {
                                "--unique",
                                "file:%p#src:%l%f",
                            },
                        },
                        chktex = { onOpenAndSave = false },
                        diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
                    },
                },
                -- clangd = {},
                denols = {},
                pyright = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = false,
                    },
                    python = {
                        analysis = {
                            -- Ignore all files for analysis to exclusively use Ruff for linting
                            ignore = { "*" },
                        },
                    },
                },
                ruff = {
                    settings = {
                        lint = {
                            enable = true,
                            ignore = { "E402" }
                        }
                    },
                },
                rust_analyzer = {
                    ["rust-analyzer"] = {
                        checkOnSave = true,
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true,
                        },
                        cachePriming = {
                            enable = true,
                        },
                    },
                },
            }

            for _, server in pairs(vim.tbl_keys(settings)) do
                if server == "ruff" then
                    require("lspconfig")[server].setup({
                        capabilities = capabilities,
                        init_options = settings[server],
                    })
                else
                    require("lspconfig")[server].setup({
                        capabilities = capabilities,
                        settings = settings[server],
                    })
                end
            end
        end,
    },

    -- formatting
    {
        "stevearc/conform.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        dependencies = { "mason.nvim" },
        keys = {
            {
                "<leader>bf",
                function()
                    require("conform").format({ async = true, timeout_ms = 5000, lsp_fallback = true })
                end,
                mode = { "n" },
                desc = "Format buffer",
            },
            {
                "<leader>bf",
                function()
                    require("conform").format({ async = true }, function(err)
                        if not err then
                            local mode = vim.api.nvim_get_mode().mode
                            if vim.startswith(string.lower(mode), "v") then
                                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n",
                                    true)
                            end
                        end
                    end)
                end,
                mode = { "v" },
                desc = "Range Format"
            }
        },
        opts = {
            formatters_by_ft = {
                bib = { "bibtex-tidy" },
                markdown = { "deno_fmt" },
                html = { "deno_fmt" },
                javascript = { "deno_fmt" },
                typescript = { "deno_fmt" },
                json = { "deno_fmt" },
                yaml = { "deno_fmt" },
                ipynb = { "deno_fmt" },
                lua = { "stylua" },
                tex = { "tex-fmt" },
                python = { "ruff_format", "injected" },
            },
        },
    },
}
