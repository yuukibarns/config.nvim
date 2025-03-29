return {
    -- GpChat
    {
        "yuukibarns/gp.nvim",
        lazy = false,
        keys = {
            {
                "<leader>gc",
                "<cmd>GpChatNew<cr>",
                mode = { "n" },
                desc = "Open Chat",
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
                -- chat_user_prefix = "💬:\\",
                -- chat_assistant_prefix = { "🤖:\\" },
                toggle_target = "abc",
                chat_free_cursor = true,
                providers = {
                    deepseek = {
                        disable = false,
                        endpoint = "https://api.deepseek.com/chat/completions",
                        secret = os.getenv("DEEPSEEK_API_KEY"),
                    },
                    alibaba = {
                        disable = true,
                        endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
                        secret = os.getenv("DASHSCOPE_API_KEY")
                    },
                    siliconflow = {
                        disable = true,
                        endpoint = "https://api.siliconflow.cn/v1/chat/completions",
                        secret = os.getenv("SILICONFLOW_API_KEY")
                    },
                    volcengine = {
                        disable = false,
                        endpoint = "https://ark.cn-beijing.volces.com/api/v3/chat/completions",
                        secret = os.getenv("VOLCENGINE_API_KEY")
                    }
                },
                agents = {
                    {
                        name = "QwenMax",
                        provider = "alibaba",
                        chat = true,
                        command = false,
                        model = {
                            model = "qwen-max",
                            temperature = 0.6,
                            top_p = 1,
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
                    {
                        name = "DeepSeekReasoner",
                        provider = "deepseek",
                        chat = true,
                        command = false,
                        model = {
                            model = "deepseek-reasoner",
                            temperature = 0.6,
                        },
                        system_prompt = "",
                    },
                    {
                        name = "DeepSeekChat(volcengine)",
                        provider = "volcengine",
                        chat = true,
                        command = false,
                        -- string with model name or table with model name and parameters
                        model = {
                            model = "deepseek-v3-250324",
                            temperature = 1.0,
                            top_p = 1,
                            min_p = 0.05,
                        },
                        system_prompt = require("gp.defaults").chat_system_prompt,
                    },
                    {
                        name = "DeepSeekReasoner(volcengine)",
                        provider = "volcengine",
                        chat = true,
                        command = false,
                        model = {
                            model = "deepseek-r1-250120",
                            temperature = 0.6,
                        },
                        system_prompt = "",
                    },
                },
            }
            require("gp").setup(conf)
        end,
    },

    -- {
    --     "olimorris/codecompanion.nvim",
    --     config = true,
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    -- },

    -- {
    --     "yetone/avante.nvim",
    --     event = "VeryLazy",
    --     lazy = false,
    --     version = false,
    --     build = "make",
    --     dependencies = {
    --         "stevearc/dressing.nvim",
    --         "nvim-lua/plenary.nvim",
    --         "MunifTanjim/nui.nvim",
    --     },
    --     opts = {
    --         provider = "deepseek",
    --         vendors = {
    --             deepseek = {
    --                 __inherited_from = "openai",
    --                 api_key_name = "DEEPSEEK_API_KEY",
    --                 endpoint = "https://api.deepseek.com",
    --                 model = "deepseek-chat",
    --             },
    --         },
    --     },
    -- },
}
