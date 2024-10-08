return {

	--snippets
	{
		"yuukibarns/LuaSnip",
		lazy = true,
		--build = "make install_jsregexp",
		dependencies = {
			-- "yuukibarns/mySnippets",
			-- opts = { path = vim.fn.stdpath("data") .. "/lazy/mySnippets/snippets" },
			"jzr/mySnippets",
			opts = { path = "~/learn/git/mySnippets/snippets" },
		},
		config = function()
			local ls = require("luasnip")
			local types = require("luasnip.util.types")

			ls.setup({
				update_events = "TextChanged,TextChangedI",
				delete_check_events = "TextChanged",
				ext_opts = {
					[types.insertNode] = { active = { virt_text = { { "●", "Boolean" } } } },
					[types.choiceNode] = { active = { virt_text = { { "○", "Special" } } } },
				},
				enable_autosnippets = true,
				--store_selection_keys = "<Tab>",
			})

			-- require("luasnip.loaders.from_lua").lazy_load()

			vim.keymap.set("i", "<C-k>", function()
				if ls.expandable() then
					ls.expand()
				end
			end, { desc = "LuaSnip Expand" })

			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if ls.locally_jumpable(1) then
					ls.jump(1)
				end
			end, { desc = "LuaSnip Forward Jump" })

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				if ls.locally_jumpable(-1) then
					ls.jump(-1)
				end
			end, { desc = "LuaSnip Backward Jump" })

			vim.keymap.set({ "i", "s" }, "<C-e>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { desc = "LuaSnip Next Choice" })
		end,
	},

	-- auto completion
	{
		"hrsh7th/nvim-cmp",
		event = { "CmdlineEnter", "InsertEnter" },
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"lukas-reineke/cmp-rg",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				formatting = {
					expandable_indicator = true,
					fields = { "abbr", "kind", "menu" },
					format = lspkind.cmp_format({
						mode = "symbol_text",
						preset = "codicons",
						maxwidth = 50,
						ellipsis_char = "…",
						menu = {
							buffer = "Buffer",
							cmdline = "Cmd",
							nvim_lsp = "Lsp",
							luasnip = "Snippet",
							path = "Path",
							rg = "RG",
						},
					}),
				},
				-- window = {
				-- 	completion = cmp.config.window.bordered({ border = "single" }),
				-- 	documentation = cmp.config.window.bordered({ border = "double" }),
				-- },
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip", option = { show_autosnippets = true } },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}, {
					{ name = "rg", keyword_length = 2 },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},

	-- auto pairs
	--{ "altermo/ultimate-autopair.nvim", event = { "InsertEnter", "CmdlineEnter" }, config = true },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local autopairs = require("nvim-autopairs")
			-- local rule = require("nvim-autopairs.rule")
			-- local conds = require("nvim-autopairs.conds")
			autopairs.setup()
			autopairs.remove_rule("'")
			--autopairs.add_rule(rule("'", "'"):with_pair(conds.not_filetypes({ "tex", "latex", "markdown" })))
		end,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},

	-- surround
	-- {
	-- 	"kylechui/nvim-surround",
	-- 	config = true,
	-- 	keys = {
	-- 		{ "cs", desc = "Change Surrounding" },
	-- 		{ "ds", desc = "Delete Surrounding" },
	-- 		{ "ys", desc = "Add Surrounding" },
	-- 	},
	-- },
}
