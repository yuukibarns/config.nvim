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
	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			preview_config = { border = "rounded" },
		},
	},
}
