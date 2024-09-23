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
			opts = { path = "~/Learn/git/mySnippets/snippets" },
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
			})

			vim.keymap.set("i", "<C-k>", function()
				if ls.expandable() then
					ls.expand()
				end
			end, { desc = "LuaSnip Expand" })
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
			local luasnip = require("luasnip")

			cmp.setup({
				mapping = {
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
					}),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						elseif cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						elseif cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
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
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip", option = { show_autosnippets = false } },
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
	{
		"yuukibarns/autoclose.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			require("autoclose").setup({
				keys = {
					['"'] = { escape = true, close = true, pair = '""', disabled_filetypes = { "markdown" } },
					["'"] = { escape = true, close = true, pair = "''", disabled_filetypes = { "markdown" } },
					["`"] = { escape = true, close = true, pair = "``", disabled_filetypes = { "markdown" } },
				},
				options = {
					disable_when_touch = true,
					disable_command_mode = true,
				},
			})
		end,
	},

	--{ "altermo/ultimate-autopair.nvim", event = { "InsertEnter", "CmdlineEnter" }, config = true },
	-- {
	-- 	"windwp/nvim-autopairs",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		local autopairs = require("nvim-autopairs")
	-- 		-- local rule = require("nvim-autopairs.rule")
	-- 		-- local conds = require("nvim-autopairs.conds")
	-- 		autopairs.setup()
	-- 		autopairs.remove_rule("'")
	-- 		autopairs.remove_rule("\"")
	-- 		--autopairs.add_rule(rule("'", "'"):with_pair(conds.not_filetypes({ "tex", "latex", "markdown" })))
	-- 	end,
	-- 	-- use opts = {} for passing setup options
	-- 	-- this is equalent to setup({}) function
	-- },

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
