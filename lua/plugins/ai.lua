return {
	-- GPT
	{
		"robitx/gp.nvim",
		lazy = false,
		keys = {
			{
				"<leader>gc",
				"<cmd>GpChatNew<cr>",
				mode = {"n"},
				desc = "Open Chat",
			},
			{
				"<leader>gt",
				"<cmd>GpChatToggle split<cr>",
				mode = { "n" },
				desc = "Resume Last Chat",
			},
			{
				"<leader>gf",
				"<cmd>GpChatFinder<cr>",
				mode = { "n" },
				desc = "Chat Finder",
			},
		},
		config = function()
			local config = {
				chat_shortcut_respond = { modes = { "n" }, shortcut = "<leader>gg" },
				chat_shortcut_delete = { modes = { "n" }, shortcut = "<leader>gd" },
				chat_shortcut_stop = { modes = { "n" }, shortcut = "<leader>gs" },
				chat_shortcut_new = { modes = { "n" }, shortcut = "<leader>gc" },
				providers = {
					moonshot = {
						disable = false,
						endpoint = "https://api.moonshot.cn/v1/chat/completions",
						secret = os.getenv("MOONSHOT_API_KEY"),
					},
					deepseek = {
						disable = false,
						endpoint = "https://api.deepseek.com/chat/completions",
						secret = os.getenv("DEEPSEEK_API_KEY"),
					},
				},
				agents = {
					{
						name = "Kimi",
						provider = "moonshot",
						chat = true,
						command = false,
						model = {
							model = "moonshot-v1-8k",
						},
						system_prompt = require("gp.defaults").chat_system_prompt,
					},
					{
						name = "DeepSeekChat",
						provider = "deepseek",
						chat = true,
						command = false,
						model = {
							model = "deepseek-chat",
							temperature = 0.6,
							top_p = 1,
							min_p = 0.05,
						},
						system_prompt = require("gp.defaults").chat_system_prompt,
					},
				},
			}
			require("gp").setup(config)
		end,
	}
}
