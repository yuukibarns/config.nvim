local opt = vim.opt_local

opt.matchpairs = { "(:)", "[:]", "{:}" }
opt.commentstring = "<!-- %s -->"

vim.api.nvim_buf_create_user_command(0, "FixInlineMath", function()
	vim.cmd("%s/\\\\(\\s*/$/g")
	vim.cmd("%s/\\s*\\\\)/$/g")
end, {})

vim.api.nvim_buf_create_user_command(0, "FixDisplayMath", function()
	vim.cmd("%s/\\\\\\[/$$/g")
	vim.cmd("%s/\\\\\\]/$$/g")
end, {})
