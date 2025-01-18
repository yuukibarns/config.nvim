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

	-- fzf fuzzy finder
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = { "echasnovski/mini.icons" },
		-- stylua: ignore
		keys = {
			{ "<leader>fb", function() require("fzf-lua").buffers() end,   desc = "Buffers" },
			{ "<leader>fd", function() require("fzf-lua").files() end,     desc = "Find Files (cwd)" },
			{ "<leader>fo", function() require("fzf-lua").oldfiles() end,  desc = "Old Files" },
			{ "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live Grep" },
			{ "<leader>fh", function() require("fzf-lua").helptags() end,  desc = "Help Tags" },
		},
		opts = {
			defaults = {
				file_icons = "mini",
				formatter = "path.dirname_first",
			},
		},
	},

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			preview_config = { border = "rounded" },
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

	-- Input method integration
	{
		"keaising/im-select.nvim",
		config = function()
			require("im_select").setup({})
		end,
	},

	-- fuzzy finder
	-- {{{{
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
	-- },}}}
}
