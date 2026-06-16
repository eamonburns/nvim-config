---@class local.Opts
---@field settings local.Settings
local M = {}

return setmetatable(M, {
  __index = function(_, k)
    if type(k) ~= "string" then
      return {}
    end

    local ok, mod = pcall(require, "custom.local." .. k)
    if ok then
      return mod
    else
      return {}
    end
  end,
})
