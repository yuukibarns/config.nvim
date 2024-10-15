-- better up/down
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Window movements
vim.keymap.set({ "n", "t" }, "<C-W>h", function()
	vim.cmd.wincmd("h")
end, { desc = "Left Window" })
vim.keymap.set({ "n", "t" }, "<C-W>j", function()
	vim.cmd.wincmd("j")
end, { desc = "Bottom Window" })
vim.keymap.set({ "n", "t" }, "<C-W>k", function()
	vim.cmd.wincmd("k")
end, { desc = "Upper Window" })
vim.keymap.set({ "n", "t" }, "<C-W>l", function()
	vim.cmd.wincmd("l")
end, { desc = "Right Window" })
-- mini.surround
vim.keymap.set({"n", "v"}, "s", "<nop>", { desc = "This key is deprecated" })
-- terminal
vim.keymap.set("n", "<leader>t", "<Cmd>new term://%:p:h//fish<CR>", { desc = "Open Terminal Below(half height)" })


