local M = {}

-- Runs `git` with the given sub-command in a vertical split.
-- Will additionally set buffer options to make it automatically
-- be deleted when hidden, and make it not listed in the buffer list.
-- And will set the key map `q` to quit the buffer
function M.run_terminal(sub_cmd)
  vim.cmd("leftabove vertical terminal git --no-pager " .. sub_cmd)
  vim.bo.bufhidden = "delete"
  vim.bo.buflisted = false
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true })
end

return M
