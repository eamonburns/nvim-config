local plugins = {}

local configure = function()
  vim.notify("Configuring LSP")
end

return {
  plugins = plugins,
  configure = configure,
}
