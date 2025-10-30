-- `nvim` helper table

local nvim = setmetatable({}, {
  __index = function(_, func)
    return vim.api["nvim_" .. func]
  end,
})

vim.print(nvim.create_buf)
vim.print(nvim.nope)
