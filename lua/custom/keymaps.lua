-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Git keymaps

vim.keymap.set("n", "<leader>gs", function()
  require("custom.git").run_terminal("status")
end, { desc = "Git [s]tatus" })
vim.keymap.set("n", "<leader>gl", function()
  require("custom.git").run_terminal("log --all --graph --oneline --decorate")
end, { desc = "Git [l]og" })
vim.keymap.set("n", "<leader>gD", function()
  require("custom.git").run_terminal("diff")
end, { desc = "Git [D]iff (all files)" })
vim.keymap.set("n", "<leader>gd", function()
  require("custom.git").run_terminal("diff %")
end, { desc = "Git [d]iff (current file)" })
vim.keymap.set("n", "<leader>gB", function()
  require("custom.git").run_terminal("blame %")
end, { desc = "Git [B]lame (current file)" })
vim.keymap.set("n", "<leader>gb", function()
  require("custom.git.blame").current_line()
end, { desc = "Git [b]lame (current line)" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Put from system clipboard" })

-- Buffer keymaps
vim.keymap.set("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "H", "<cmd>bprev<cr>", { desc = "Previous buffer" })

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
