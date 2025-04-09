return {
    -- file explorer
    {
        "stevearc/oil.nvim",
        lazy = false,
        cmd = "Oil",
        keys = { { "<leader>o", "<Cmd>Oil<CR>", desc = "Open Oil" } },
        opts = {
            default_file_explorer = true,
            delete_to_trash = true,
            columns = {
                "icon",
                "size",
            },
            skip_confirm_for_simple_edits = true,
            keymaps = {
                ["<C-[>"] = "actions.close",
                ["<2-LeftMouse>"] = "actions.select",
                ["<RightMouse>"] = "actions.parent",
            },
        },
        dependencies = { "echasnovski/mini.icons" },
    },

    -- fzf fuzzy finder
    {
        "ibhagwan/fzf-lua",
        lazy = false,
        cmd = "FzfLua",
        dependencies = { "echasnovski/mini.icons" },
        keys = {
            {
                "<leader>fb",
                "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
                desc = "Switch Buffer",
            },
            {
                "<leader>fd",
                "<cmd>FzfLua files<cr>",
                desc = "Find Files (cwd)"
            },
            {
                "<leader>fo",
                "<cmd>FzfLua oldfiles<cr>",
                desc = "Old Files"
            },
            {
                "<leader>fr",
                "<cmd>FzfLua resume<cr>",
                desc = "Fzf Resume"
            },
            {
                "<leader>fg",
                "<cmd>FzfLua live_grep<cr>",
                desc = "Live Grep"
            },
            {
                "<leader>fl",
                "<cmd>FzfLua lines<cr>",
                desc = "Lines"
            },
            -- improve default mappings
            {
                "grr",
                "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>",
                desc = "References"
            },
            {
                "gri",
                "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>",
                desc = "Goto Implementation"
            },
        },
        opts = {
            winopts = {
                height = 0.95,
                width = 0.90,
                preview = {
                    vertical = "down:60%",
                    flip_columns = 120,
                    scrollbar = false,
                    winopts = {
                        conceallevel = 2,
                    }
                }
            }
        },
    },

    -- git signs
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        keys = {
            {
                "]h",
                "<Cmd>Gitsigns next_hunk<CR>",
                desc = "Next Hunk",
            },
            {
                "[h",
                "<Cmd>Gitsigns prev_hunk<CR>",
                desc = "Prev Hunk",
            },
            {
                "<leader>hr",
                "<Cmd>Gitsigns reset_hunk<CR>",
                desc = "Hunk Reset"
            },
            {
                "<leader>hp",
                "<Cmd>Gitsigns preview_hunk<CR>",
                desc = "Hunk Preview",
            }
        },
        opts = {
            preview_config = { border = "rounded" },
            signcolumn = false,
            numhl = true,
        },
    },

    -- which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- leap
    {
        "ggandor/leap.nvim",
        -- dependencies = { "tpope/vim-repeat" },
        commit = '5ae080b646021bbb6e1d8715b155b1e633e28166',
        config = function()
            require("leap").create_default_mappings()
        end,
    },

    -- {
    --  'MagicDuck/grug-far.nvim',
    --  config = function()
    --      require('grug-far').setup({
    --          -- options, see Configuration section below
    --          -- there are no required options atm
    --          -- engine = 'ripgrep' is default, but 'astgrep' can be specified
    --      });
    --  end
    -- },
    --
    -- Input method integration
    {
        "keaising/im-select.nvim",
        config = function()
            require("im_select").setup({})
        end,
    },

    -- fuzzy finder
    -- {
    --  "nvim-telescope/telescope.nvim",
    --  cmd = "Telescope",
    --  dependencies = { "nvim-lua/plenary.nvim" },
    --  keys = {
    --      {
    --          "<leader>rg",
    --          function()
    --              require("telescope.builtin").live_grep()
    --          end,
    --          desc = "Live Grep",
    --      },
    --      {
    --          "<leader>fd",
    --          function()
    --              require("telescope.builtin").find_files()
    --          end,
    --          desc = "Find Files in CWD",
    --      },
    --      {
    --          "<leader>fb",
    --          function()
    --              require("telescope.builtin").buffers()
    --          end,
    --          desc = "Find Buffers",
    --      },
    --  },
    --  config = function()
    --      local telescope = require("telescope")
    --
    --      telescope.setup({
    --          defaults = {
    --              sorting_strategy = "ascending",
    --              layout_config = { prompt_position = "top" },
    --              prompt_prefix = "   ",
    --              selection_caret = " ",
    --              file_ignore_patterns = { "%.jpeg$", "%.jpg$", "%.png$", ".DS_Store" },
    --          },
    --          pickers = {
    --              buffers = {
    --                  sort_lastused = true,
    --                  previewer = true,
    --              },
    --              find_files = { follow = true },
    --              grep_string = { path_display = { "shorten" } },
    --              live_grep = { path_display = { "shorten" } },
    --          },
    --      })
    --  end,
    -- },
}
