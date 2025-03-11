return {

    --snippets
    {
        "yuukibarns/LuaSnip",
        lazy = true,
        --build = "make install_jsregexp",
        dependencies = {
            -- "yuukibarns/mySnippets",
            -- url = "git@gitee.com:yuukibarns/mySnippets.git",
            -- opts = { path = vim.fn.stdpath("data") .. "/lazy/mySnippets/snippets" },
            "jzr/mySnippets",
            opts = { path = "~/mySnippets/snippets" },
        },
        config = function()
            local ls = require("luasnip")
            local types = require("luasnip.util.types")

            ls.setup({
                update_events = "TextChanged,TextChangedI",
                delete_check_events = "TextChanged",
                ext_opts = {
                    [types.insertNode] = { active = { virt_text = { { "●", "Boolean" } } } },
                    [types.choiceNode] = { active = { virt_text = { { "○", "Special" } } } },
                },
                enable_autosnippets = true,
            })
        end,
    },

    -- nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        event = { "CmdlineEnter", "InsertEnter" },
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-emoji",
            "lukas-reineke/cmp-rg",
            "saadparwaiz1/cmp_luasnip",
            "echasnovski/mini.icons",
            {
                "uga-rosa/cmp-dictionary",
                config = function()
                    require("cmp_dictionary").setup({
                        paths = { vim.fn.stdpath("config") .. "/spell/en.utf-8.add" },
                        exact_length = 2,
                        first_case_insensitive = true,
                        max_number_items = 16,
                    })
                end
            }
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local mini_icons = require("mini.icons")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable() then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable() then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-l>"] = cmp.mapping(function(fallback)
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            fallback()
                        end
                    end, { "i" }),
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    expandable_indicator = true,
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        local maxwidth = 30
                        local icon = mini_icons.get("lsp", item.kind)

                        item.menu_hl_group = "CmpItemKind" .. item.kind
                        item.kind = icon .. " "
                        if vim.fn.strchars(item.abbr) > maxwidth then
                            item.abbr = vim.fn.strcharpart(item.abbr, 0, maxwidth) .. "…"
                        end
                        item.menu = ({
                            buffer = "[Buf]",
                            cmdline = "[Cmd]",
                            nvim_lsp = "[Lsp]",
                            luasnip = "[Snip]",
                            path = "[Path]",
                            dictionary = "[Dict]",
                            emoji = "[Emoji]"
                            -- rg = "[RG]",
                        })[entry.source.name]
                        return item
                    end,
                },
                window = {
                    completion = {
                        scrollbar = false,
                        side_padding = 1,
                        winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
                        border = "single",
                    },
                    documentation = {
                        border = "single",
                        winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
                    },
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip", option = { show_autosnippets = true } },
                }, {
                    { name = "path" },
                    { name = "buffer" },
                    { name = "dictionary", keyword_length = 1 },
                    { name = "emoji" }
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },

    -- blink
    -- {
    --  'saghen/blink.cmp',
    --  dependencies = { 'yuukibarns/LuaSnip' },
    --  -- use a release tag to download pre-built binaries
    --  version = '*',
    --  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    --  -- build = 'cargo build --release',
    --  -- If you use nix, you can build from source using latest nightly rust with:
    --  -- build = 'nix run .#build-plugin',
    --
    --  ---@module 'blink.cmp'
    --  ---@type blink.cmp.Config
    --  opts = {
    --      snippets = { preset = 'luasnip' },
    --      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
    --      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
    --      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    --      --
    --      -- All presets have the following mappings:
    --      -- C-space: Open menu or open docs if already open
    --      -- C-e: Hide menu
    --      -- C-k: Toggle signature help
    --      --
    --      -- See the full "keymap" documentation for information on defining your own keymap.
    --      keymap = { preset = 'default' },
    --
    --      appearance = {
    --          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
    --          -- Useful for when your theme doesn't support blink.cmp
    --          -- Will be removed in a future release
    --          use_nvim_cmp_as_default = true,
    --          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    --          -- Adjusts spacing to ensure icons are aligned
    --          nerd_font_variant = 'normal'
    --      },
    --
    --      -- Default list of enabled providers defined so that you can extend it
    --      -- elsewhere in your config, without redefining it, due to `opts_extend`
    --      sources = {
    --          default = function(ctx)
    --              local success, node = pcall(vim.treesitter.get_node)
    --              if vim.bo.filetype == 'lua' then
    --                  return { 'lsp', 'path', "omni" }
    --              elseif success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
    --                  return { 'buffer' }
    --              elseif success and node and vim.tbl_contains({ "inline_formula" }, node:type()) then
    --                  return { "lsp", "snippets" }
    --              else
    --                  return { 'lsp', 'path', 'snippets', 'buffer' }
    --              end
    --          end
    --      },
    --
    --      -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
    --      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    --      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --      --
    --      -- See the fuzzy documentation for more information
    --      fuzzy = { implementation = "prefer_rust_with_warning" }
    --  },
    --  opts_extend = { "sources.default" }
    -- },

    -- surround
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {
            move_cursor = "sticky",
            keymaps = {
                visual = "gs",
            },
        },
    },

    -- auto pairs
    {
        "m4xshen/autoclose.nvim",
        event = { "InsertEnter" },
        config = function()
            require("autoclose").setup({
                keys = {
                    ['"'] = { escape = true, close = true, pair = '""' },
                    ["'"] = { escape = true, close = false, pair = "''" },
                    ["`"] = { escape = true, close = true, pair = "``" },
                },
                options = {
                    disable_when_touch = true,
                    disable_command_mode = true,
                    disabled_filetypes = { "tex", "markdown" },
                },
            })
        end,
    },
}
