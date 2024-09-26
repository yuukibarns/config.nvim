-- local opt = vim.opt_local
-- opt.shiftwidth = 2

--opt.conceallevel = 2
-- fixed in v0.10.1
-- opt.smoothscroll = false
--opt.spell = true
--vim.treesitter.start()

-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
--vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- vim.wo.conceallevel = 2
-- vim.wo.spell = true

--vim.keymap.set("i", "<M-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { buffer = true, desc = "Fix Last Miss-Spelling" })
-- vim.keymap.set(
-- 	"n",
-- 	"mk",
-- 	"<cmd>%s/\\\\(\\s*/$/g<cr><cmd>%s/\\s*\\\\)/$/g<cr>",
-- 	{ buffer = true, desc = "replace latex math with native markdown" }
-- )
-- vim.keymap.set(
-- 	"n",
-- 	"dm",
-- 	"<cmd>%s/\\\\\\[/$$/g<cr><cmd>%s/\\\\\\]/$$/g<cr>",
-- 	{ buffer = true, desc = "replace latex math with native markdown" }
-- )

vim.api.nvim_buf_create_user_command(0, "FixInlineMath", function()
	vim.cmd("%s/\\\\(\\s*/$/g")
	vim.cmd("%s/\\s*\\\\)/$/g")
end, {})

vim.api.nvim_buf_create_user_command(0, "FixDisplayMath", function()
	vim.cmd("%s/\\\\\\[/$$/g")
	vim.cmd("%s/\\\\\\]/$$/g")
end, {})

-- vim.api.nvim_buf_create_user_command(0, "FixMath", function()
-- 	vim.cmd("%s/\\\\\\[/$$/g")
-- 	vim.cmd("%s/\\\\\\]/$$/g")
-- 	vim.cmd("%s/\\\\(\\s*/$/g")
-- 	vim.cmd("%s/\\s*\\\\)/$/g")
-- end, {})

-- Define a custom command to open the current markdown file with viv
-- vim.api.nvim_buf_create_user_command(0, "Vivfy", function()
-- 	local filename = vim.fn.expand("%:p")
-- 	local command = "viv " .. filename
-- 	os.execute(command)
-- end, {})
