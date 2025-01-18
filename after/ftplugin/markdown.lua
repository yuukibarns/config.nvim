local opt = vim.opt_local

opt.matchpairs = { "(:)", "[:]", "{:}" }
opt.commentstring = "<!-- %s -->"
opt.formatoptions = "qnjl"
opt.textwidth = 100

vim.api.nvim_buf_set_keymap(0, "n", "<C-h>", "[s1z=", { desc = "Crect Last Spelling" })

vim.api.nvim_buf_create_user_command(0, "FixInlineMath", function()
	vim.cmd("%s/\\\\(\\s*/$/g")
	vim.cmd("%s/\\s*\\\\)/$/g")
end, {})

vim.api.nvim_buf_create_user_command(0, "FixDisplayMath", function()
	vim.cmd("%s/\\\\\\[/$$/g")
	vim.cmd("%s/\\\\\\]/$$/g")
end, {})

local chars = { "$" }

for _, char in ipairs(chars) do
	vim.api.nvim_buf_set_keymap(
		0,
		"v",
		"i" .. char,
		string.format(":<C-u>normal! T%svt%s<CR>", char, char),
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		0,
		"v",
		"a" .. char,
		string.format(":<C-u>normal! F%svf%s<CR>", char, char),
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		0,
		"n",
		"di" .. char,
		string.format(":<C-u>normal! T%svt%sd<CR>", char, char),
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		0,
		"n",
		"da" .. char,
		string.format(":<C-u>normal! F%svf%sd<CR>", char, char),
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		0,
		"n",
		"ci" .. char,
		string.format(":<C-u>normal! T%svt%sd<CR>i", char, char),
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		0,
		"n",
		"ca" .. char,
		string.format(":<C-u>normal! F%svf%sd<CR>i", char, char),
		{ noremap = true, silent = true }
	)
end
