-- SPDX-License-Identifier: MIT
-- Copyright (c) Eamon Burns

local M = {}

local enabled = (vim.env.NVIM_TRAINING_WHEELS ~= "0")

---Create a mapping for `discouraged` to print a suggestion to use the `preferred` mapping
---@param discouraged string # Discouraged command
---@param preferred string # Mapping to suggest
---@param behavior? "passthrough"|"replace"|"none" # What the mapping should do. "passthrough": (default) Print warning and execute mapping, "replace": Execute `preferred` mapping instead of `discouraged`, "none": do nothing
---@param mode? string|string[] # What modes this mapping is in. Default is "n"
function M.map(discouraged, preferred, behavior, mode)
  if not enabled then
    print("training-wheels not enabled")
    return
  end

  behavior = behavior or "passthrough"
  mode = mode or "n"

  vim.keymap.set(mode, discouraged, function()
    print("Training wheels: You probably meant `" .. preferred .. "` instead of `" .. discouraged .. "`")

    if behavior == "passthrough" then
      nvim.feedkeys(vim.api.nvim_replace_termcodes(discouraged, true, true, true), vim.fn.mode(), false)
    elseif behavior == "replace" then
      nvim.feedkeys(vim.api.nvim_replace_termcodes(preferred, true, true, true), vim.fn.mode(), false)
    end
  end, {
    desc = "Training Wheels: Prefer `" .. preferred .. "` over `" .. discouraged .. "`",
    buffer = true, -- NOTE: I don't know if this is the best way to do this
  })
end

return M
