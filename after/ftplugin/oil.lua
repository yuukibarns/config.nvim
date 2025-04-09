local oil = require("oil")
vim.keymap.set("n", "<leader>tm", function()
    local cwd = oil.get_current_dir(0)
    return "<Cmd>new term://" .. cwd .. "/fish<CR>"
end, { desc = "Open Terminal Below(half height)", buffer = true, expr = true, silent = true, remap = false })
