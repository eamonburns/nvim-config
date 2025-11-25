---@param repo string
local function gh(repo)
  return "https://github.com/" .. repo
end

local plugins = {
  {
    src = gh("nvim-treesitter/nvim-treesitter"),
    version = "main",
    data = {
      on_change = function()
        vim.cmd["TSUpdate"]()
      end
    },
  },
}

local configure = function()
  -- TODO: Ensure commands are installed (e.g. tree-sitter, curl?)

  -- Automatically download parser for current file if available and not already installed
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_autostart", { clear = true }),
    callback = function(args)
      local treesitter = require("nvim-treesitter")
      local lang = vim.treesitter.language.get_lang(args.match)

      if lang and vim.list_contains(treesitter.get_available(), lang) then
        if not vim.list_contains(treesitter.get_installed(), lang) then
          -- Install parser and then start treesitter
          treesitter.install(lang):await(function()
            vim.treesitter.start(args.buf)
          end)
        else
          -- Start treesitter
          vim.treesitter.start(args.buf)
        end
      end
    end,
    desc = "Automatically start treesitter for buffer (installing parser if not already)",
  })
end

return {
  plugins = plugins,
  configure = configure,
}
