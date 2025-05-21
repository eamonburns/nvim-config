-- SPDX-License-Identifier: MIT
-- Copyright (c) Eamon Burns

local M = {}

local enabled = (vim.env.NVIM_TRAINING_WHEELS ~= "0")

---@class training-wheels.map.Opts : vim.keymap.set.Opts
---@field behavior?
---|"passthrough"
---|"replace"
---|"none"
---@field mode? string|string[]

---Create a mapping for `discouraged` to print a suggestion to use the `preferred` mapping
---@param discouraged string # Discouraged command
---@param preferred string # Mapping to suggest
---@param behavior? "passthrough"|"replace"|"none" # What the mapping should do. "passthrough": (default) Print warning and execute mapping, "replace": Execute `preferred` mapping instead of `discouraged`, "none": do nothing
---@param mode? string|string[] # What modes this mapping is in. Default is "n"
---@param opts vim.keymap.set.Opts # Options passed to `vim.keymap.set`, with the description overridden
function M.map(discouraged, preferred, behavior, mode, opts)
  if not enabled then
    return
  end

  behavior = behavior or "passthrough"
  mode = mode or "n"
  opts = opts or {}
  opts.desc = "Training Wheels: Prefer `" .. preferred .. "` over `" .. discouraged .. "`"

  vim.keymap.set(mode, discouraged, function()
    print("Training wheels: You probably meant `" .. preferred .. "` instead of `" .. discouraged .. "`")

    if behavior == "passthrough" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(discouraged, true, true, true), vim.fn.mode(), false)
    elseif behavior == "replace" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(preferred, true, true, true), vim.fn.mode(), false)
    end
  end, opts)
end

return M
