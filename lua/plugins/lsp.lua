return {

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = {
				ensure_installed = {
					-- lsp
					--"lua-language-server",
					"texlab",
					"clangd",
					"jdtls",
					--"ruff",
					--"pylyzer",
					"pyright",
					"rust-analyzer",
					-- formatter
					"bibtex-tidy",
					"latexindent",
					"prettierd",
					"stylua",
				},
			},
		},
		opts = { ui = { border = "rounded", height = 0.8 } },
	},

	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason.nvim" },
		config = function()
			-- diagnostic keymaps
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Loclist Diagnostics" })

			-- diagnostics config
			vim.diagnostic.config({
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = " ",
						[vim.diagnostic.severity.HINT] = " ",
					},
				},
			})

			-- lspconfig

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local settings = {
				-- lua_ls = {
				-- 	Lua = {
				-- 		workspace = { checkThirdParty = false },
				-- 		hint = { enable = true },
				-- 		completion = { callSnippet = "Replace" },
				-- 		telemetry = { enable = false },
				-- 	},
				-- },
				texlab = {
					texlab = {
						build = {
							forwardSearchAfter = false,
							executable = "C:/texlive/2024/bin/windows/latexmk.exe",
							args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = false,
						},
						forwardSearch = {
							executable = "D:/SumatraPDF/SumatraPDF.exe",
							args = {
								"-reuse-instance",
								"%p",
								"-forward-search",
								"%f",
								"%l",
							},
						},
						chktex = { onOpenAndSave = false },
						diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
					},
				},
				clangd = {},
				jdtls = {},
				-- ruff = {},
				-- pylyzer = {
				-- 	python = {
				-- 		checkOnType = false,
				-- 		diagnostics = false,
				-- 		inlayHints = true,
				-- 		smartCompletion = true,
				-- 	},
				-- },
				pyright = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
						},
					},
				},
				rust_analyzer = {
					["rust-analyzer"] = {
						checkOnSave = false,
						cargo = {
							buildScripts = {
								enable = false,
							},
						},
						procMacro = {
							enable = false,
						},
					},
				},
			}

			for _, server in pairs(vim.tbl_keys(settings)) do
				require("lspconfig")[server].setup({
					capabilities = capabilities,
					settings = settings[server],
				})
			end
		end,
	},

	--clangd_extensions
	-- {
	-- 	"p00f/clangd_extensions.nvim",
	-- 	ft = { "c", "cpp" },
	-- 	config = true,
	-- },

	-- code-runner
	--{ "CRAG666/code_runner.nvim", ft = { "c", "cpp", "python", "java" }, config = true },

	--markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- symbols outline
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>cs", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {
			-- Your setup opts here
		},
	},
	-- {
	-- 	"stevearc/aerial.nvim",
	-- 	cmd = "AerialToggle",
	-- 	opts = {
	-- 		backends = { "lsp", "treesitter", "markdown", "man" },
	-- 		layout = { resize_to_content = false },
	-- 		attach_mode = "global",
	-- 		icons = vim.tbl_extend("force", require("lspkind").presets.codicons, {
	-- 			Array = "󰅨 ",
	-- 			Boolean = " ",
	-- 			Constant = " ",
	-- 			Key = " ",
	-- 			Number = "󰎠 ",
	-- 			Null = "󰟢 ",
	-- 			Object = " ",
	-- 			Struct = " ",
	-- 			String = "󰅳 ",
	-- 		}),
	-- 		filter_kind = false,
	-- 		show_guides = true,
	-- 	},
	--     -- stylua: ignore
	--     keys = { { "<leader>cs", function() require("aerial").toggle() end, desc = "Aerial (Symbols)" } },
	-- },

	-- lsp enhancement
	-- {
	-- 	"nvimdev/lspsaga.nvim",
	-- 	event = { "LspAttach" },
	-- 		-- stylua: ignore
	-- 		--keys = { { "<M-g>", function() require("lspsaga.floaterm"):open_float_terminal({ "lazygit" }) end, mode = { "n", "t" }, desc = "LazyGit" } },
	-- 		keys = { { "<M-g>", function() require("lspsaga.floaterm"):open_float_terminal({ "gitui" }) end, mode = { "n", "t" }, desc = "GitUI" } },
	-- 	config = function()
	-- 		require("lspsaga").setup({
	-- 			symbol_in_winbar = { enable = false },
	-- 			lightbulb = { enable = false },
	-- 			outline = { auto_preview = false },
	-- 			floaterm = { height = 1, width = 1 },
	-- 		})
	--
	-- 		vim.keymap.set("n", "gh", function()
	-- 			require("lspsaga.finder"):new({})
	-- 		end, { desc = "Lsp Finder" })
	--
	-- 		vim.keymap.set("n", "<M-o>", function()
	-- 			require("lspsaga.symbol"):outline()
	-- 		end, { desc = "Lspsaga Outline" })
	-- 	end,
	-- },

	-- formatting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = { "mason.nvim" },
		-- keys = {
		-- 	{
		-- 		"<leader>a",
		-- 		function()
		-- 			require("conform").format({ formatters = { "injected" } })
		-- 		end,
		-- 		mode = { "n", "v" },
		-- 		desc = "Format Injected Langs",
		-- 	},
		-- },
		keys = {
			{
				"<leader>a",
				function()
					require("conform").format({ timeout_ms = 5000, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				bib = { "bibtex-tidy" },
				--markdown = { "prettierd", "injected" },
				markdown = { "prettierd" },
				--["markdown.mdx"] = { "prettierd", "injected" },
				lua = { "stylua" },
				tex = { "latexindent" },
			},
			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes
				local ignore_filetypes = { "tex" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				-- Disable with a global or buffer-local variable
				-- if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				-- 	return
				-- end
				-- Disable autoformat for files in a certain path
				-- local bufname = vim.api.nvim_buf_get_name(bufnr)
				-- if bufname:match("/node_modules/") then
				-- 	return
				-- end
				-- ...additional logic...
				return { timeout_ms = 1000, lsp_fallback = true }
			end,
			-- format_on_save = {
			-- 	timeout_ms = 3000,
			-- 	lsp_fallback = true,
			-- },
		},
	},
}
