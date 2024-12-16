-- better up/down
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- terminal
vim.keymap.set("n", "<leader>t", "<Cmd>new term://%:p:h//fish<CR>", { desc = "Open Terminal Below(half height)" })


