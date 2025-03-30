return {
    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("nvim-treesitter.configs").setup({
                modules = {},
                sync_install = false,
                auto_install = true,
                ignore_install = {},
                highlight = {
                    enable = true,
                },
                ensure_installed = {
                    -- markdown
                    "markdown",
                    "markdown_inline",
                    "latex",
                    "html",
                    "scheme",
                    -- vim
                    "vim",
                    "vimdoc",
                    -- languages
                    "lua",
                    "c",
                    "cpp",
                    "python",
                    "rust",
                    -- shell
                    "bash",
                    "fish",
                    -- comment
                    "comment",
                },
                textobjects = {
                    move = {
                        enable = true,
                        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
                        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
                        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
                    },
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ao"] = "@block.outer",
                            ["io"] = "@block.inner",
                            ["au"] = "@call.outer",
                            ["iu"] = "@call.inner",
                            ["id"] = "@number.inner",
                            ["ak"] = "@frame.outer",
                            ["ik"] = "@frame.inner",
                            -- ["aa"] = "@parameter.outer",
                            -- ["ia"] = "@parameter.inner"
                            -- You can also use captures from other query groups like `locals.scm`
                            -- ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * method: eg 'v' or 'o'
                        -- and should return the mode ('v', 'V', or '<c-v>') or a table
                        -- mapping query_strings to modes.
                        selection_modes = {
                            ['@parameter.outer'] = 'v',
                            ['@function.outer'] = 'V',
                            ['@class.outer'] = 'V',
                            ["@block.outer"] = "V"
                            -- ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        -- If you set this to `true` (default is `false`) then any textobject is
                        -- extended to include preceding or succeeding whitespace. Succeeding
                        -- whitespace has priority in order to act similarly to eg the built-in
                        -- `ap`.
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * selection_mode: eg 'v'
                        -- and should return true or false
                        include_surrounding_whitespace = false,
                    },
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- context
    {
        "nvim-treesitter/nvim-treesitter-context",
        command = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
        config = function()
            require("treesitter-context").setup({
                max_lines = 4,
                mode = "topline",
                trim_scope = "outer",
                -- separator = "-",
            })
        end,
    },
}
