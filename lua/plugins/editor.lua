return {
	-- file explorer
	{
		"stevearc/oil.nvim",
		lazy = false,
		cmd = "Oil",
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
		dependencies = { "echasnovski/mini.icons" },
	},

	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = { "echasnovski/mini.icons" },
		-- stylua: ignore
		keys = {
			{ "<leader>fb", function () require("fzf-lua").buffers() end, desc = "Buffers" },
			{ "<leader>fd", function () require("fzf-lua").files() end, desc = "Find Files (cwd)" },
			{ "<leader>fo", function () require("fzf-lua").oldfiles() end, desc = "Old Files" },
			{ "<leader>fg", function () require("fzf-lua").live_grep() end, desc = "Live Grep" },
			{ "<leader>fh", function () require("fzf-lua").helptags() end, desc = "Help Tags" },
		},
		opts = {
			defaults = {
				file_icons = "mini",
				formatter = "path.dirname_first",
			},
		},
	},

	-- fuzzy finder
	-- {
	-- 	"nvim-telescope/telescope.nvim",
	-- 	cmd = "Telescope",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	keys = {
	-- 		{
	-- 			"<leader>rg",
	-- 			function()
	-- 				require("telescope.builtin").live_grep()
	-- 			end,
	-- 			desc = "Live Grep",
	-- 		},
	-- 		{
	-- 			"<leader>fd",
	-- 			function()
	-- 				require("telescope.builtin").find_files()
	-- 			end,
	-- 			desc = "Find Files in CWD",
	-- 		},
	-- 		{
	-- 			"<leader>fb",
	-- 			function()
	-- 				require("telescope.builtin").buffers()
	-- 			end,
	-- 			desc = "Find Buffers",
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		local telescope = require("telescope")
	--
	-- 		telescope.setup({
	-- 			defaults = {
	-- 				sorting_strategy = "ascending",
	-- 				layout_config = { prompt_position = "top" },
	-- 				prompt_prefix = "   ",
	-- 				selection_caret = " ",
	-- 				file_ignore_patterns = { "%.jpeg$", "%.jpg$", "%.png$", ".DS_Store" },
	-- 			},
	-- 			pickers = {
	-- 				buffers = {
	-- 					sort_lastused = true,
	-- 					previewer = true,
	-- 				},
	-- 				find_files = { follow = true },
	-- 				grep_string = { path_display = { "shorten" } },
	-- 				live_grep = { path_display = { "shorten" } },
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			preview_config = { border = "rounded" },
		},
	},

	-- search and jump
	-- {
	-- 	"yuukibarns/sj.nvim",
	-- 	config = function()
	-- 		local sj = require("sj")
	--
	-- 		sj.setup({
	-- 			separator = ";",
	-- 			stop_on_fail = false,
	-- 			keymaps = {
	-- 				cancel = "<Esc>",
	-- 				delete_prev_char = "<C-H>",
	-- 			},
	-- 		})
	-- 		vim.keymap.set({ "n", "v" }, "f", sj.search_forward)
	-- 		vim.keymap.set({ "n", "v" }, "F", sj.search_backward)
	-- 	end,
	-- },
}
