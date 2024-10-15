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
			"echasnovski/mini.icons",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				mapping = {
					["<C-y>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm()
						else
							fallback()
						end
					end, {"i"}),
					["<C-n>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i" }),
					["<C-p>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i" }),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				formatting = {
					expandable_indicator = true,
					fields = { "abbr", "kind", "menu" },
					format = function(entry, item)
						local maxwidth = 30
						local icon = require("mini.icons").get("lsp", item.kind)

						if vim.fn.strchars(item.abbr) > maxwidth then
							item.abbr = vim.fn.strcharpart(item.abbr, 0, maxwidth) .. "…"
						end
						item.menu = ({
							buffer = "Buf",
							cmdline = "Cmd",
							nvim_lsp = "Lsp",
							luasnip = "Snip",
							path = "Path",
							rg = "RG",
						})[entry.source.name]
						item.kind = icon .. " " .. item.kind
						return item
					end,
				},
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

	-- surround
	{
		"echasnovski/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup({})
		end,
	},

	-- auto pairs
	{
		"m4xshen/autoclose.nvim",
		event = { "InsertEnter" },
		config = function()
			require("autoclose").setup({
				keys = {
					['"'] = { escape = true, close = true, pair = '""' },
					["'"] = { escape = true, close = true, pair = "''" },
					["`"] = { escape = true, close = true, pair = "``" },
				},
				options = {
					disable_when_touch = true,
					disable_command_mode = true,
					disabled_filetypes = { "tex", "markdown" },
				},
			})
		end,
	},
}
