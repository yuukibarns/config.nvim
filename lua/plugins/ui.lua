return {
    -- NvChad
    {
        "yuukibarns/base46",
        lazy = true,
        build = function()
            require("base46").load_all_highlights()
        end,
    },

    {
        "nvchad/ui",
        dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
        config = function()
            require("nvchad")
        end,
    },

    -- starter
    {
        "yuukibarns/alpha-nvim",
        dependencies = {
            "echasnovski/mini.icons",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local theta = require("alpha.themes.theta")
            theta.header.val = require("alpha.isaac_fortune")
            theta.config.layout = {
                { type = "padding", val = 2 },
                theta.header,
                { type = "padding", val = 3 },
                theta.section_mru,
                { type = "padding", val = 2 },
            }
            require("alpha").setup(theta.config)
        end,
    },

    -- dead color column
    { "Bekaboo/deadcolumn.nvim" },

    -- icons
    {
        "echasnovski/mini.icons",
        lazy = false,
        opts = {
            lsp = {
                ["function"] = { glyph = "" },
                object = { glyph = "" },
                value = { glyph = "" },
            },
        },
    },

    -- smear cursor
    {
        "sphamba/smear-cursor.nvim",
        opts = {
            smear_between_buffers = true,
            smear_between_neighbor_lines = false,
            scroll_buffer_space = true,
            legacy_computing_symbols_support = false,
            smear_insert_mode = false,
            -- smooth cursor without smear
            stiffness = 0.5,
            trailing_stiffness = 0.49,
            never_draw_over_target = false,
            cursor_color = "#FFFFFF"
        },
    }
}
