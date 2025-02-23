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
		keys = {
			{
				"<leader>fb",
				"<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{
				"<leader>fd",
				"<cmd>FzfLua files<cr>",
				desc = "Find Files (cwd)"
			},
			{
				"<leader>fo",
				"<cmd>FzfLua oldfiles<cr>",
				desc = "Old Files"
			},
			{
				"<leader>fg",
				"<cmd>FzfLua live_grep<cr>",
				desc = "Live Grep"
			},
			-- improve default mappings
			{
				"grr",
				"<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>",
				desc = "References"
			},
			{
				"gri",
				"<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>",
				desc = "Goto Implementation"
			},
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
}
