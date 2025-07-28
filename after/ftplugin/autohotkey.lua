vim.keymap.set("n", "<leader>xx", function()
  vim.ui.open(vim.fn.expand("%:p"))
  print("Ran Autohotkey script: " .. vim.fn.expand("%:p"))
end, { desc = "Run AutoHotkey script", buffer = true })
