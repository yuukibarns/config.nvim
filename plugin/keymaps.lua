-- better up/down
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move to window using the <meta> movement keys
vim.keymap.set({ "n", "t" }, "<M-h>", function()
	vim.cmd.wincmd("h")
end, { desc = "Left Window" })
vim.keymap.set({ "n", "t" }, "<M-j>", function()
	vim.cmd.wincmd("j")
end, { desc = "Bottom Window" })
vim.keymap.set({ "n", "t" }, "<M-k>", function()
	vim.cmd.wincmd("k")
end, { desc = "Upper Window" })
vim.keymap.set({ "n", "t" }, "<M-l>", function()
	vim.cmd.wincmd("l")
end, { desc = "Right Window" })

-- Disable <C-P> <C-N> for keyword completion in insert mode
vim.keymap.set("i", "<C-P>", "<nop>", { desc = "This key is deprecated" })
vim.keymap.set("i", "<C-N>", "<nop>", { desc = "This key is deprecated" })
vim.keymap.set({"n", "v"}, "s", "<nop>", { desc = "This key is deprecated" })

-- terminal
vim.keymap.set("n", "<M-t>", "<Cmd>new term://%:p:h//fish<CR>", { desc = "Open Terminal Below(half height)" })
