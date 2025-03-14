return {

    -- cmdline tools and lsp servers
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = { ui = { border = "rounded", height = 0.8 } },
    },

    -- lspconfig
    { -- {{{
        "neovim/nvim-lspconfig",
        dependencies = { "mason.nvim" },
        config = function()
            -- diagnostic keymaps
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Loclist Diagnostics" })

            -- diagnostics config
            vim.diagnostic.config({
                virtual_text = { spacing = 4, prefix = "●" },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                    },
                },
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
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            -- local capabilities = require("blink.cmp").get_lsp_capabilities()
            local handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
            }
            -- local capabilities = require("blink.cmp").get_lsp_capabilities()

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
                    init_options = {
                        settings = {
                            -- Ruff language server settings go here
                        },
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
                require("lspconfig")[server].setup({
                    capabilities = capabilities,
                    handlers = handlers,
                    settings = settings[server],
                })
            end
        end,
    }, -- }}}

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
            formatters = {
                -- deno_fmt = {
                --     meta = {
                --         url = "https://deno.land/manual/tools/formatter",
                --         description =
                --         "use [deno](https://deno.land/) to format typescript, javascript/json and markdown.",
                --     },
                --     command = "deno",
                --     cond = function(self, ctx)
                --         local unstable_extensions = {
                --             astro = "astro",
                --             svelte = "svelte",
                --             vue = "vue",
                --         }
                --         local extensions = vim.tbl_extend("keep", {
                --             css = "css",
                --             html = "html",
                --             javascript = "js",
                --             javascriptreact = "jsx",
                --             json = "json",
                --             jsonc = "jsonc",
                --             less = "less",
                --             markdown = "md",
                --             sass = "sass",
                --             scss = "scss",
                --             typescript = "ts",
                --             typescriptreact = "tsx",
                --             yaml = "yml",
                --         }, unstable_extensions)
                --         return extensions[vim.bo[ctx.buf].filetype] ~= nil
                --     end,
                --     args = function(self, ctx)
                --         local log = require("conform.log")
                --         local unstable_extensions = {
                --             astro = "astro",
                --             svelte = "svelte",
                --             vue = "vue",
                --         }
                --         local extensions = vim.tbl_extend("keep", {
                --             css = "css",
                --             html = "html",
                --             javascript = "js",
                --             javascriptreact = "jsx",
                --             json = "json",
                --             jsonc = "jsonc",
                --             less = "less",
                --             markdown = "md",
                --             sass = "sass",
                --             scss = "scss",
                --             typescript = "ts",
                --             typescriptreact = "tsx",
                --             yaml = "yml",
                --         }, unstable_extensions)
                --         local extension = extensions[vim.bo[ctx.buf].filetype]
                --         local formatter_args = {
                --             "fmt",
                --             "-",
                --             "--ext",
                --             extension,
                --         }
                --         if extension == "md" then
                --             vim.list_extend(formatter_args, { "--line-width", "100" })
                --         end
                --
                --         if unstable_extensions[extension] then
                --             log.info(
                --                 "adding `--unstable-component` to enable formatting of .%s files. see the deno documentation for more information: https://docs.deno.com/runtime/reference/cli/formatter/#formatting-options-unstable-component",
                --                 extension
                --             )
                --             formatter_args = vim.list_extend(formatter_args, { "--unstable-component" })
                --         end
                --
                --         return formatter_args
                --     end,
                -- },
                -- injected = {
                --  options = {
                --      -- Set individual option values
                --      ignore_errors = true,
                --  },
                -- }
            },
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
                tex = { "latexindent" },
                python = { "ruff_format" },
            },
        },
    },
}
