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
