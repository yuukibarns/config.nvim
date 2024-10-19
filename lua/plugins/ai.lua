return {
	-- GPT
	{
		"robitx/gp.nvim",
		lazy = true,
		keys = {
			{
				"<leader>gc",
				"<cmd>GpChatNew<cr>",
				mode = { "n" },
				desc = "Start new Chat",
			},
			{
				"<leader>gt",
				"<cmd>GpChatToggle<cr>",
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
			local conf = {
				chat_shortcut_respond = { modes = { "n" }, shortcut = "<leader>gg" },
				chat_shortcut_delete = { modes = { "n" }, shortcut = "<leader>gd" },
				chat_shortcut_stop = { modes = { "n" }, shortcut = "<leader>gs" },
				chat_shortcut_new = { modes = { "n" }, shortcut = "<leader>gc" },
				providers = {
					["glm-4"] = {
						disable = false,
						endpoint = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
						secret = os.getenv("GLM_4_KEY"),
					},
					deepseek = {
						disable = false,
						endpoint = "https://api.deepseek.com/chat/completions",
						secret = os.getenv("DEEPSEEK_API_KEY"),
					},
				},
				agents = {
					{
						name = "ChatGPT3-5",
						disable = true,
					},
					{
						name = "GhatGLM-4-plus",
						provider = "glm-4",
						chat = true,
						command = false,
						-- string with model name or table with model name and parameters
						model = {
							model = "glm-4-plus",
						},
						system_prompt = require("gp.defaults").chat_system_prompt,
					},
					{
						name = "DeepSeekChat",
						provider = "deepseek",
						chat = true,
						command = false,
						-- string with model name or table with model name and parameters
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
			require("gp").setup(conf)
		end,
	},
}
