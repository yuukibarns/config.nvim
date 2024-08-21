return {
	{
		"robitx/gp.nvim",
		config = function()
			local conf = {
				providers = {
					deepseek = {
						disable = false,
						endpoint = "https://api.deepseek.com/chat/completions",
						secret = os.getenv("DEEPSEEK_API_KEY"),
					},
					groq = {
						disable = true,
						endpoint = "https://api.groq.com/openai/v1/chat/completions",
						secret = os.getenv("GROQ_API_KEY"),
					},
					openai = {
						disable = true,
						endpoint = "https://api.openai.com/v1/chat/completions",
						-- secret = os.getenv("OPENAI_API_KEY"),
					},
				},
				agents = {
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
					{
						name = "DeepSeekCoder",
						provider = "deepseek",
						chat = false,
						command = true,
						model = {
							model = "deepseek-coder",
							temperature = 0.4,
							top_p = 1,
							min_p = 0.05,
						},
						system_prompt = require("gp.defaults").code_system_prompt,
					},
				},
			}
			require("gp").setup(conf)

			-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
			-- stylua: ignore start
			vim.keymap.set({"n", "i"}, "<C-g>c", "<cmd>GpChatNew tabnew<cr>", { desc = "Open Chat In New Tab" })
			vim.keymap.set({"n", "i"}, "<C-g>t", "<cmd>GpChatToggle tabnew<cr>", { desc = "Resume Last Chat In New Tab" })
			vim.keymap.set({"n", "i"}, "<C-g>f", "<cmd>GpChatFinder<cr>", { desc = "Chat Finder" })
			-- stylua: ignore end
		end,
	},

	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	build = ":Copilot auth",
	-- 	cmd = "Copilot",
	-- 	dependencies = { "zbirenbaum/copilot-cmp", config = true },
	-- 	---@module "copilot"
	-- 	---@class copilot_config
	-- 	opts = {
	-- 		panel = { enabled = false },
	-- 		suggestion = { enabled = false },
	-- 	},
	-- },
}
