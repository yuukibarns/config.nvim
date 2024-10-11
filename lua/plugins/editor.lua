return {
	-- file explorer
	{
		"stevearc/oil.nvim",
		lazy = false,
		cmd = "Oil",
		-- sytlua: ignore
		keys = { { "<leader>o", "<Cmd>Oil<CR>", desc = "Open Oil" } },
		opts = {
			default_file_explorer = true,
			columns = {
				"icon",
				"size",
			},
			skip_confirm_for_simple_edits = true,
			keymaps = {
				["<C-[>"] = "actions.close",
			},
		},
		dependencies = {
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
		},
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>rg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Live Grep",
			},
			{
				"<leader>fd",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find Files in CWD",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Find Buffers",
			},
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = { prompt_position = "top" },
					prompt_prefix = "   ",
					selection_caret = " ",
					file_ignore_patterns = { "%.jpeg$", "%.jpg$", "%.png$", ".DS_Store" },
				},
				pickers = {
					buffers = {
						sort_lastused = true,
						previewer = true,
					},
					find_files = { follow = true },
					grep_string = { path_display = { "shorten" } },
					live_grep = { path_display = { "shorten" } },
				},
			})
		end,
	},

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			preview_config = { border = "rounded" },
		},
	},
}
