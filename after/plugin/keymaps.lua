-- better up/down
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- terminal
vim.keymap.set("n", "<leader>tm", "<Cmd>new term://%:p:h//fish<CR>", { desc = "Open Terminal Below(half height)" })

-- Toggle transparency in nvchad
vim.api.nvim_set_keymap("n", "<leader>tt", "", {
    callback = function()
        require("base46").toggle_transparency()
    end
})

-- For LuaSnip's select mode
vim.keymap.set('s', '<leader>a', "<C-g>o<Esc>a", { noremap = true, silent = true })

-- LSP not needed after 0.11
-- vim.api.nvim_create_user_command("LspFormat", function()
--     vim.lsp.buf.format()
-- end, {})
-- vim.api.nvim_create_user_command("LspRename", function()
--     vim.lsp.buf.rename()
-- end, {})
-- vim.api.nvim_create_user_command("LspReference", function()
--     vim.lsp.buf.references()
-- end, {})
-- vim.api.nvim_create_user_command("LspImplementation", function()
--     vim.lsp.buf.implementation()
-- end, {})
-- vim.api.nvim_create_user_command("LspDefinition", function()
--     vim.lsp.buf.definition()
-- end, {})
-- vim.api.nvim_create_user_command("LspDeclaration", function()
--     vim.lsp.buf.declaration()
-- end, {})
-- vim.api.nvim_create_user_command("LspCodeAction", function()
--     vim.lsp.buf.code_action()
-- end, {})
-- vim.api.nvim_create_user_command("LspSubtypeHierarchy", function()
--     vim.lsp.buf.typehierarchy("subtypes")
-- end, {})
-- vim.api.nvim_create_user_command("LspSuptypeHierarchy", function()
--     vim.lsp.buf.typehierarchy("supertypes")
-- end, {})
-- vim.api.nvim_create_user_command("LspIncomingCall", function()
--     vim.lsp.buf.incoming_calls()
-- end, {})
-- vim.api.nvim_create_user_command("LspOutgoingCall", function()
--     vim.lsp.buf.outgoing_calls()
-- end, {})
--
-- -- Lsp Signature Help
-- vim.keymap.set({ "i", "v" }, "<C-S>", function()
--     vim.lsp.buf.signature_help()
-- end, { desc = "Lsp Signature Help" })

-- Switch between buffers
-- Not needed since 0.11
-- vim.keymap.set("n", "]b", "<Cmd>bnext<CR>", { desc = "Next Buffer" })
-- vim.keymap.set("n", "[b", "<Cmd>bNext<CR>", { desc = "Previous Buffer" })
