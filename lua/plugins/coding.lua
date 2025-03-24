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
    -- {
    --     "hrsh7th/nvim-cmp",
    --     event = { "CmdlineEnter", "InsertEnter" },
    --     dependencies = {
    --         "hrsh7th/cmp-buffer",
    --         "hrsh7th/cmp-cmdline",
    --         "hrsh7th/cmp-nvim-lsp",
    --         "hrsh7th/cmp-path",
    --         "hrsh7th/cmp-emoji",
    --         "lukas-reineke/cmp-rg",
    --         "saadparwaiz1/cmp_luasnip",
    --         "echasnovski/mini.icons",
    --         {
    --             "uga-rosa/cmp-dictionary",
    --             config = function()
    --                 require("cmp_dictionary").setup({
    --                     paths = { vim.fn.stdpath("config") .. "/spell/en.utf-8.add" },
    --                     exact_length = 2,
    --                     first_case_insensitive = true,
    --                     max_number_items = 16,
    --                 })
    --             end
    --         }
    --     },
    --     config = function()
    --         local cmp = require("cmp")
    --         local luasnip = require("luasnip")
    --         local mini_icons = require("mini.icons")
    --
    --         cmp.setup({
    --             mapping = cmp.mapping.preset.insert({
    --                 ["<Tab>"] = cmp.mapping(function(fallback)
    --                     if luasnip.locally_jumpable() then
    --                         luasnip.jump(1)
    --                     else
    --                         fallback()
    --                     end
    --                 end, { "i", "s" }),
    --                 ["<S-Tab>"] = cmp.mapping(function(fallback)
    --                     if luasnip.locally_jumpable() then
    --                         luasnip.jump(-1)
    --                     else
    --                         fallback()
    --                     end
    --                 end, { "i", "s" }),
    --                 ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    --                 ["<C-l>"] = cmp.mapping(function(fallback)
    --                     if luasnip.expandable() then
    --                         luasnip.expand()
    --                     else
    --                         fallback()
    --                     end
    --                 end, { "i" }),
    --             }),
    --             snippet = {
    --                 expand = function(args)
    --                     luasnip.lsp_expand(args.body)
    --                 end,
    --             },
    --             formatting = {
    --                 expandable_indicator = true,
    --                 fields = { "kind", "abbr", "menu" },
    --                 format = function(entry, item)
    --                     local maxwidth = 30
    --                     local icon = mini_icons.get("lsp", item.kind)
    --
    --                     item.menu_hl_group = "CmpItemKind" .. item.kind
    --                     item.kind = icon .. " "
    --                     if vim.fn.strchars(item.abbr) > maxwidth then
    --                         item.abbr = vim.fn.strcharpart(item.abbr, 0, maxwidth) .. "…"
    --                     end
    --                     item.menu = ({
    --                         buffer = "[Buf]",
    --                         cmdline = "[Cmd]",
    --                         nvim_lsp = "[Lsp]",
    --                         luasnip = "[Snip]",
    --                         path = "[Path]",
    --                         dictionary = "[Dict]",
    --                         emoji = "[Emoji]"
    --                         -- rg = "[RG]",
    --                     })[entry.source.name]
    --                     return item
    --                 end,
    --             },
    --             window = {
    --                 completion = {
    --                     scrollbar = false,
    --                     side_padding = 1,
    --                     winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
    --                     border = "single",
    --                 },
    --                 documentation = {
    --                     border = "single",
    --                     winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
    --                 },
    --             },
    --             sources = cmp.config.sources({
    --                 { name = "nvim_lsp" },
    --                 { name = "luasnip", option = { show_autosnippets = true } },
    --             }, {
    --                 { name = "path" },
    --                 { name = "buffer" },
    --                 { name = "dictionary", keyword_length = 1 },
    --                 { name = "emoji" }
    --             }),
    --         })
    --
    --         cmp.setup.cmdline({ "/", "?" }, {
    --             mapping = cmp.mapping.preset.cmdline(),
    --             sources = {
    --                 { name = "buffer" },
    --             },
    --         })
    --
    --         cmp.setup.cmdline(":", {
    --             mapping = cmp.mapping.preset.cmdline(),
    --             sources = cmp.config.sources({
    --                 { name = "path" },
    --             }, {
    --                 { name = "cmdline" },
    --             }),
    --         })
    --     end,
    -- },

    -- blink
    {
        'Saghen/blink.cmp',
        dependencies = {
            'yuukibarns/LuaSnip',
            "moyiz/blink-emoji.nvim",
            {
                'Kaiser-Yang/blink-cmp-dictionary',
                dependencies = { 'nvim-lua/plenary.nvim' }
            }
        },
        -- version = '*',
        build = 'cargo build --release',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = { preset = 'luasnip' },
            keymap = {
                preset = 'default',
                ['<C-S>'] = { 'show', 'show_documentation', 'hide_documentation' },
            },
            appearance = {
                nerd_font_variant = 'normal'
            },
            cmdline = {
                completion = {
                    menu = {
                        auto_show = true
                    },
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = true,
                        },
                    },
                }
            },
            completion = {
                accept = {
                    dot_repeat = false,
                },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    }
                },
                menu = {
                    border = 'single',
                    scrollbar = false,
                    draw = {
                        columns = { { 'kind_icon' }, { 'label' } },
                    }
                },
                documentation = { window = { border = "single", scrollbar = false } },
            },
            signature = { window = { border = 'single' } },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', 'dictionary', "emoji" },
                providers = {
                    lsp = {
                        fallbacks = {},
                        score_offset = 3,
                    },
                    snippets = {
                        score_offset = 5,
                    },
                    dictionary = {
                        module = 'blink-cmp-dictionary',
                        min_keyword_length = 2,
                        -- max_items = 16,
                        opts = {
                            dictionary_files = function()
                                if vim.bo.filetype == "markdown" or vim.bo.filetype == "tex" then
                                    return { vim.fn.stdpath("config") .. "/spell/en.utf-8.add" }
                                else
                                    return nil
                                end
                            end,
                        }
                    },
                    emoji = {
                        module = "blink-emoji",
                        score_offset = 15,        -- Tune by preference
                        opts = { insert = true }, -- Insert emoji (default) or complete its name
                        should_show_items = function()
                            return vim.tbl_contains(
                                { "gitcommit", "markdown" },
                                vim.o.filetype
                            )
                        end,
                    }
                }
            },
            fuzzy = {
                sorts = {
                    'score',
                    'sort_text',
                }
            }
        },
        opts_extend = { "sources.default" }
    },

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
        "yuukibarns/autoclose.nvim",
        event = { "InsertEnter" },
        config = function()
            require("autoclose").setup({
                keys = {
                    ["'"] = { escape = true, close = true, pair = "''" },
                    ["`"] = { escape = true, close = true, pair = "``" },
                    -- Resolve conflicts with LuaSnip snippets
                    ['"'] = { escape = true, close = true, pair = '""', before_cursor_regex = "[%w)%]}]" },
                    ["("] = { escape = false, close = true, pair = "()", before_cursor_regex = ";" },
                    ["["] = { escape = false, close = true, pair = "[]", before_cursor_regex = ";" },
                    ["{"] = { escape = false, close = true, pair = "{}", before_cursor_regex = ";" },
                },
                options = {
                    disable_when_touch = true,
                    disable_command_mode = true,
                    pair_spaces = true,
                    auto_indent = true,
                    disabled_filetypes = { "tex", "markdown", "gitcommit" },
                },
            })
        end,
    },
}
