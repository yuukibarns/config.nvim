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

	-- colorschemes
	-- {
	-- 	"AlexvZyl/nordic.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("nordic").setup({
	-- 			on_highlight = function(highlights, palette)
	-- 				highlights.Indentline = {
	-- 					fg = palette.gray3,
	-- 				}
	-- 				highlights.IndentLineCurrent = {
	-- 					link = "Indentline",
	-- 				}
	-- 				highlights.TreesitterContext = {
	-- 					bg = palette.bg,
	-- 				}
	-- 				highlights.TreesitterContextLineNumber = {
	-- 					link = "LineNr",
	-- 				}
	-- 				highlights.TreesitterContextBottom = {
	-- 					bg = palette.bg,
	-- 				}
	-- 				highlights.TreesitterContextSeparator = {
	-- 					fg = palette.grey5,
	-- 				}
	-- 				highlights["@markup.strong"] = {
	-- 					fg = palette.yellow.dim,
	-- 					bold = true,
	-- 				}
	-- 				highlights["@markup.italic"] = {
	-- 					fg = palette.yellow.dim,
	-- 					italic = true,
	-- 				}
	-- 				highlights.Conceal = {
	-- 					link = "@markup.math",
	-- 				}
	-- 				highlights["@none"] = {
	-- 					fg = palette.fg,
	-- 				}
	-- 				highlights.StatusLine = {
	-- 					fg = palette.fg,
	-- 					bg = palette.gray1,
	-- 				}
	-- 				highlights.Folded = {
	-- 					bg = palette.bg,
	-- 					fg = palette.fg, }
	-- 				highlights.MatchParen = {
	-- 					bg = palette.gray3,
	-- 					bold = true,
	-- 				}
	-- 			end,
	-- 			cursorline = {
	-- 				theme = "light",
	-- 				blend = 0.5,
	-- 			},
	-- 		})
	-- 		vim.cmd([[colorscheme nordic]])
	-- 	end,
	-- },
}
