return {

	-- colorschemes
	{
		"yuukibarns/onedarkpro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("onedarkpro").setup({
				highlights = {
					-- \sin
					Conceal = { link = "Special" },
					-- \text{abc}
					["@none.latex"] = { fg = "${fg}" },
					-- TreesitterContext
					TreesitterContext = { bg = "${bg}" },
					TreesitterContextSeparator = { bg = "${bg}" },
					-- Spell
					SpellBad = { underline = true },
					SpellCap = { underline = true },
					SpellRare = { underline = true },
					SpellLocal = { underline = true },
					MatchParen = { fg = "#56b6c2", bold = true },
				},
				options = {
					cursorline = true,
				},
			})
			vim.cmd([[colorscheme onedark]])
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "moon",
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "transparent", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
				on_highlights = function(highlights, colors)
					highlights.Conceal = { link = "Special" }
					highlights["@none"] = { fg = "#c8d3f5" }
					highlights.TreesitterContext = { bg = colors.bg }
					highlights.TreesitterContextSeparator = { fg = "#589ed7", bg = colors.bg }
					-- highlights.TreesitterContextBottom = { underline = true }
				end,
			})
		end,
	},

	-- better vim.notify
	{
		"rcarriga/nvim-notify",
		-- stylua: ignore
		keys = { { "<M-u>", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Delete All Notifications" } },
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
	},

	-- winbar
	{ "Bekaboo/dropbar.nvim", config = true },

	--statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					-- theme = "tokyonight",
					theme = "onedark",
				},
				tabline = {
					lualine_a = { "buffers" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "tabs" },
				},
				extensions = { "oil" },
			})
		end,
	},

	-- noicer ui
	{
		"folke/noice.nvim",
		-- version = "4.4.7", --the latest v4.5.0 has some problems
		event = { "VeryLazy" },
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		config = true,
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
			views = {
				mini = {
					win_options = {
						winblend = 0,
					},
				},
			},
		},
	},

	-- start screen
	{
		"nvimdev/dashboard-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			config = {
				week_header = { enable = true },
				disable_move = false,
				shortcut = {
					{ desc = "󰚰 Update", group = "Identifier", action = "Lazy update", key = "u" },
					{ desc = "󰀶 Files", group = "Directory", action = "Telescope find_files", key = "f" },
					{
						desc = " Quit",
						group = "String",
						action = function()
							vim.api.nvim_input("<Cmd>qa<CR>")
						end,
						key = "q",
					},
				},
				project = { limit = 5 },
				mru = { limit = 10, cwd_only = true },
			},
		},
	},

	-- rainbow delimiters
	{
		"HiPhish/rainbow-delimiters.nvim",
		submodules = false,
		init = function()
			vim.g.rainbow_delimiters = { query = { latex = "rainbow-delimiters" } }
		end,
	},

	-- indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup({
				scope = { highlight = highlight },
				exclude = { filetypes = { "conf", "dashboard", "markdown" } },
			})

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end,
	},
}
