return {
	-- NvChad
	{
		"nvchad/ui",
		config = function()
			require("nvchad")
		end,
	},
	{
		"nvchad/base46",
		lazy = true,
		config = function()
			require("base46").load_all_highlights()
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
				{ type = "padding", val = 4 },
				theta.header,
				{ type = "padding", val = 3 },
				theta.section_mru,
				{ type = "padding", val = 2 },
			}
			require("alpha").setup(theta.config)
		end,
	},
 	-- smear-cursor
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			cursor_color = "#FFFFFF",
			distance_stop_animating = 2,
			legacy_computing_symbols_support = true,
		},
	},

	-- icons
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			lsp = {
				["function"] = { glyph = "" },
				object = { glyph = "" },
				value = { glyph = "" },
			},
		},
	},
}
