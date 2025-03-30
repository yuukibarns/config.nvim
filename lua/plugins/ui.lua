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
}
