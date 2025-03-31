return {
    -- filesype plugin for markdown
    {
        "yuukibarns/markdown.nvim",
        ft = { "markdown", "tex", "python" },

        config = function()
            require("markdown").setup({
                conceals = {
                    enabled = {
                        "amssymb",
                        "core",
                        "delim",
                        "font",
                        "greek",
                        "leftright",
                        "math",
                        "script",
                    },
                },
            })
        end,
    },

    -- Faster LuaLS setup for Neovim
    { "folke/lazydev.nvim", ft = "lua", config = true },

    {
        "jannis-baum/vivify.vim",
        lazy = true,
        cmd = { "Vivify" },
        keys = {
            {
                "<leader>cp",
                ft = "markdown",
                "<cmd>Vivify<cr>",
                desc = "Vivify Preview",
            },
        },
    }

    -- markdown preview
    -- {
    -- 	"toppair/peek.nvim",
    -- 	ft = { "markdown" },
    -- 	cmd = { "PeekOpen", "PeekClose" },
    -- 	build = "deno task --quiet build:fast",
    -- 	keys = {
    -- 		{
    -- 			"<leader>cp",
    -- 			ft = "markdown",
    -- 			"<cmd>PeekOpen<cr>",
    -- 		}
    -- 	},
    -- 	config = function()
    -- 		require("peek").setup({
    -- 			app = "browser",
    -- 		})
    -- 		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    -- 		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    -- 	end,
    -- },

    -- {
    --     "iamcco/markdown-preview.nvim",
    --     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    --     ft = { "markdown" },
    --     build = function()
    --         require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    --         vim.fn["mkdp#util#install"]()
    --     end,
    --     keys = {
    --         {
    --             "<leader>cp",
    --             ft = "markdown",
    --             "<cmd>MarkdownPreviewToggle<cr>",
    --             desc = "Markdown Preview",
    --         },
    --     },
    -- },
}
