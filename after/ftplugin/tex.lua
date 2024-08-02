--vim.treesitter.start()

-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--
-- vim.g.tex_flavor = "latex"
--
-- vim.wo.conceallevel = 2
-- vim.wo.spell = true
--
-- vim.keymap.set("i", "<M-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { buffer = true, desc = "Fix Last Miss-Spelling" })
-- texlab
vim.keymap.set(
	"n",
	"<M-b>",
	"<Cmd>TexlabBuild<CR>",
	{ desc = "Build the current buffer", buffer = true, noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<M-f>",
	"<Cmd>TexlabForward<CR>",
	{ desc = "Forward search from current position", buffer = true, noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<M-x>",
	"<Cmd>TexlabCancelBuild<CR>",
	{ desc = "Cancel the current build", buffer = true, noremap = true, silent = true }
)
