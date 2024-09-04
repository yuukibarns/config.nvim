return {

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		-- dependencies = {
		-- 	"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- 	opts = {
		-- 		ensure_installed = {
		-- 			-- lsp
		-- 			--"lua-language-server",
		-- 			"texlab",
		-- 			"clangd",
		-- 			"jdtls",
		-- 			--"ruff",
		-- 			--"pylyzer",
		-- 			"pyright",
		-- 			"rust-analyzer",
		-- 			-- formatter
		-- 			"bibtex-tidy",
		-- 			"latexindent",
		-- 			"prettierd",
		-- 			"stylua",
		-- 		},
		-- 	},
		-- },
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

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client == nil then
						return
					end
					if client.name == "ruff" then
						-- Disable hover in favor of Pyright
						client.server_capabilities.hoverProvider = false
					end
				end,
				desc = "LSP: Disable hover capability from Ruff",
			})

			-- lspconfig

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local settings = {
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						completion = { callSnippet = "Replace" },
					},
				},
				texlab = {
					texlab = {
						build = {
							forwardSearchAfter = false,
							executable = "/usr/bin/latexmk",
							args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = false,
						},
						forwardSearch = {
							executable = "/bin/sioyek",
							args = {
								"--execute-command",
								"toggle_synctex",
								"--inverse-search",
								"texlab inverse-search -i \"%%1\" -l %%2",
								"--forward-search-file",
								"%f",
								"--forward-search-line",
								"%l",
								"%p",
							},
						},
						chktex = { onOpenAndSave = false },
						diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
					},
				},
				clangd = {},
				-- jedi_language_server = {},
				pyright = {
					pyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = false,
					},
					python = {
						analysis = {
							-- Ignore all files for analysis to exclusively use Ruff for linting
							ignore = { "*" },
						},
					},
				},
				ruff = {
					init_options = {
						settings = {
							-- Ruff language server settings go here
						},
					},
				},
				rust_analyzer = {
					["rust-analyzer"] = {
						checkOnSave = false,
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
						cachePriming = {
							enable = true,
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
				markdown = { "prettier" },
				--["markdown.mdx"] = { "prettierd", "injected" },
				lua = { "stylua" },
				tex = { "latexindent" },
				python = { "ruff_format" },
			},
			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes
				local ignore_filetypes = { "tex", "python", "rust" }
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
