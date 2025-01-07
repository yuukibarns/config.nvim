return {
	-- NvChad
	{
		"nvchad/base46",
		lazy = true,
		build = function()
			require("base46").load_all_highlights()
		end,
	},
	{
		"nvchad/ui",
		config = function()
			require("nvchad")
		end,
	},

	-- {
	-- 	"rose-pine/neovim",
	-- 	name = "rose-pine",
	-- 	config = function()
	-- 		require("rose-pine").setup({
	-- 			styles = {
	-- 				bold = true,
	-- 				italic = true,
	-- 				transparency = true,
	-- 			},
	-- 		})
	-- 		vim.cmd("colorscheme rose-pine")
	-- 	end,
	-- },
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

	-- tabline
	{
		"echasnovski/mini.tabline",
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			tabpage_section = "right",
			set_vim_settings = true,
			format = function(buf_id, label)
				local suffix = vim.bo[buf_id].modified and "+ " or ""
				return require("mini.tabline").default_format(buf_id, label) .. suffix
			end,
		},
	},

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
		version = "0.3.3",
		cond = not vim.g.neovide,
		opts = {
			-- cursor_color = "#ffa460",
			distance_stop_animating = 2,
			legacy_computing_symbols_support = true,
			-- smear_to_cmd = false,
		},
	},
}
