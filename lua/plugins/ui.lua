return {
	-- starter
	{
		"yuukibarns/alpha-nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local theta = require("alpha.themes.theta")
			theta.header.val = require("alpha.fortune")
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
