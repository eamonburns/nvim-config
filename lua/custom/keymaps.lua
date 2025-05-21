-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Git keymaps

-- Runs `git` with the given sub-command in a vertical split.
-- Will additionally set buffer options to make it automatically
-- be deleted when hidden, and make it not listed in the buffer list.
-- And will set the key map `q` to quit the buffer
local function run_git(sub_cmd)
  vim.cmd("leftabove vertical terminal git --no-pager " .. sub_cmd)
  vim.bo.bufhidden = "delete"
  vim.bo.buflisted = false
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true })
end
vim.keymap.set("n", "<leader>gs", function()
  run_git("status")
end, { desc = "Git [s]tatus" })
vim.keymap.set("n", "<leader>gl", function()
  run_git("log --all --graph --oneline --decorate")
end, { desc = "Git [l]og" })
vim.keymap.set("n", "<leader>gD", function()
  run_git("diff")
end, { desc = "Git [D]iff (all files)" })
vim.keymap.set("n", "<leader>gd", function()
  run_git("diff %")
end, { desc = "Git [d]iff (current file)" })

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
local tw = require("training-wheels")
tw.map("<left>", "h", "none")
tw.map("<right>", "l", "none")
tw.map("<up>", "k", "none")
tw.map("<down>", "j", "none")
